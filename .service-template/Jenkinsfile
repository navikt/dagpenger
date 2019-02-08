pipeline {
  agent any
  environment {
    DEPLOYMENT = readYaml(file: './nais.yaml')
    APPLICATION_NAME = "${DEPLOYMENT.metadata.name}"
    ZONE = "${DEPLOYMENT.metadata.annotations.zone}"
    NAMESPACE = "${DEPLOYMENT.metadata.namespace}"
    VERSION = sh(label: 'Get git sha1 as version', script: 'git rev-parse --short HEAD', returnStdout: true).trim()
  }

  stages {
    stage('Build') {
      // Create tested artifacts that can be used for later stages
      environment {
        DOCKER_REPO = 'repo.adeo.no:5443'
        DOCKER_IMAGE_VERSION = '${DOCKER_REPO}/${APPLICATION_NAME}:${VERSION}'
      }

      steps {
        sh label: 'Install dependencies', script: """
          ./gradlew assemble
        """

        // Should run a set of tests like: unit, functional, component,
        // coverage, contract, lint, mutation.
        sh label: 'Test code', script: """
          ./gradlew test
        """

        sh label: 'Build artifact', script: """
          ./gradlew build
        """

        withDockerRegistry(
          credentialsId: 'repo.adeo.no',
          url: "https://${DOCKER_REPO}"
        ) {
          sh label: 'Build and push Docker image', script: """
            docker build . --pull -t ${DOCKER_IMAGE_VERSION}
            docker push ${DOCKER_IMAGE_VERSION} || true
          """
        }

        sh label: 'Prepare service contract', script: """
          sed 's/latest/${VERSION}/' nais.yaml | tee nais-deployed.yaml
        """
      }

      post {
        always {
          publishHTML target: [
            allowMissing: true,
            alwaysLinkToLastBuild: false,
            keepAll: true,
            reportDir: 'build/reports/tests/test',
            reportFiles: 'index.html',
            reportName: 'Test coverage'
          ]

          junit 'build/test-results/test/*.xml'
        }

        success {
          archiveArtifacts artifacts: 'nais*.yaml', fingerprint: true
        }
      }
    }

    stage('Acceptance testing') {
      stages {
        stage('Deploy to pre-production') {
          steps {
            sh label: 'Deploy with kubectl', script: """
              kubectl config use-context dev-${env.ZONE}
              kubectl apply -n ${env.NAMESPACE} -f nais-deployed.yaml --wait
              kubectl rollout status -w deployment/${APPLICATION_NAME}
            """
          }
        }

        stage('Run tests') {
          // Since these tests usually are quite expensive, running them as
          // separate stages allows distributing them on seperate agents
          failFast true

          parallel {
            stage('User Acceptance Tests') {
              agent any

              when {
                beforeAgent true
                expression {
                  sh(
                    label: 'Does the repository define any UAT tests?',
                    script: 'test -f ./scripts/test/uat',
                    returnStatus: true
                  ) == 0
                }
              }

              steps {
                sh label: 'User Acceptance Tests', script: """
                  ./scripts/test/uat || true
                """
              }
            }

            stage('Integration Tests') {
              agent any

              when {
                beforeAgent true
                expression {
                  sh(
                    label: 'Does the repository define any integration tests?',
                    script: 'test -f ./scripts/test/integration',
                    returnStatus: true
                  ) == 0
                }
              }

              steps {
                sh label: 'Integration Tests', script: """
                  ./scripts/test/integration || true
                """
              }
            }

            stage('Benchmark Tests') {
              agent any

              when {
                beforeAgent true
                expression {
                  sh(
                    label: 'Does the repository define any benchmark tests?',
                    script: 'test -f ./scripts/test/benchmark',
                    returnStatus: true
                  ) == 0
                }
              }

              steps {
                sh label: 'Run benchmark', script: """
                  ./scripts/test/benchmark || true
                """
              }
            }
          }
        }
      }
    }

    stage('Deploy') {
      when { branch 'master' }

      steps {
        sh label: 'Deploy with kubectl', script: """
          kubectl config use-context prod-${env.ZONE}
          kubectl apply -n ${env.NAMESPACE} -f nais.yaml --wait
          kubectl rollout status -w deployment/${APPLICATION_NAME}
        """
      }
    }

    stage('Release') {
      when { branch 'master' }

      steps {
        sh "echo true"
      }
    }
  }
}
