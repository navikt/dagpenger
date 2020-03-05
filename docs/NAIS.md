# NAIS

Vi bruker et [Kustomize](https://github.com/kubernetes-sigs/kustomize) og [dette mønsteret](https://kubectl.docs.kubernetes.io/pages/app_composition_and_deployment/structure_repositories.html) 
for å dele NAIS/k8s konfigurasjon på tvers av alle applikasjonene våre.

Base konfigurasjon: https://github.com/navikt/dagpenger/tree/master/nais

## Ny app?

1. Kopier [.service-template/nais](.service-template/nais) inn i applikasjonen din.
2. Oppdater `app-name` i base/kustomize.yaml med navn på appen (uten dp-prefix)
3. Oppdater `image` i base/nais.yaml med riktig navn på image. Husk å ta med :latest tag.
