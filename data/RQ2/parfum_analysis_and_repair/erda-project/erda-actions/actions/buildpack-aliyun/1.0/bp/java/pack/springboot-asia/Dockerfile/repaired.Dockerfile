# Build app image
FROM {{BP_DOCKER_BASE_REGISTRY}}/erda/terminus-openjdk:v1.8.0.242-asia

# set default TZ, modify through `--build-arg TZ=XXX`