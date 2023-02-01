# Download:
#   curl -o gateway-service-1.0.jar http://people.redhat.com/cdarby/rhte/msa-and-service-mesh/coolstore-gateway-1.0.0-SNAPSHOT.jar

# Build:
#   docker build --rm -t gateway-service:1.0 -f Dockerfile.gateway .
#   docker tag gateway-service:1.0 docker.io/rhtgptetraining/gateway-service:1.0
#   docker push docker.io/rhtgptetraining/gateway-service:1.0