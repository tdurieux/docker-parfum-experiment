# ARGS for defining tags
ARG  BASE_DOCKER_ALLEGREX_IMAGE
ARG  BASE_DOCKER_EXTRA_IMAGE

# Allegrex stage of Dockerfile
FROM $BASE_DOCKER_ALLEGREX_IMAGE

# Extra stage of Dockerfile
FROM $BASE_DOCKER_EXTRA_IMAGE

# Second stage of Dockerfile