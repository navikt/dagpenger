#!/usr/bin/env bash
APPS=(dp-regel-api dp-inntekt-api dp-regel-api-arena-adapter dp-regel-periode dp-regel-grunnlag dp-regel-sats dp-regel-minsteinntekt)
COMPOSE_DIR=${PWD}


build_and_up() {
    for APP in ${APPS[*]}
    do
        printf "\nBuilding %s\n" ${APP}
        cd ./../${APP}
        if ./gradlew clean assemble ; then
            echo "Build succeeded"
        else
            echo "Build failed"
            exit 1
        fi
    done
    up
}

up() {
   cd ${COMPOSE_DIR}
    printf "\n***********************************  Start docker-compose ***********************************\n"
    docker-compose -f docker-compose-lel.yml up --remove-orphans  --build
}

down(){
   cd ${COMPOSE_DIR}
   docker-compose -f docker-compose-lel.yml down --remove-orphans
}

usage()
{
    cat << USAGE >&2
Usage:
    build-and-run.sh up/down
USAGE
    exit 1
}

# process arguments
while [[ $# -gt 0 ]]
    do
        case "$1" in
            "up")
                build_and_up
                break
                ;;
            "down")
                down
                break
                ;;
            "compose")
                up
                break
                ;;
             *)
                echo "Unknown argument: $1"
                usage
                ;;
        esac
    end
done


if [[ $# -lt 2 ]]
then
        usage
fi