# Download:
#   curl -o catalog-service-1.0.jar http://people.redhat.com/cdarby/rhte/msa-and-service-mesh/catalog-service-1.0.0-SNAPSHOT.jar

# Build:
#   docker build --rm -t catalog-service:1.0 -f Dockerfile.catalog .
#   docker tag catalog-service:1.0 docker.io/rhtgptetraining/catalog-service:1.0
#   docker push docker.io/rhtgptetraining/catalog-service:1.0