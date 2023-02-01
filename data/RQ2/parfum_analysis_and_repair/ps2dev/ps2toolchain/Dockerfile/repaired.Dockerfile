# ARGS for defining tags
ARG  BASE_DOCKER_DVP_IMAGE
ARG  BASE_DOCKER_IOP_IMAGE
ARG  BASE_DOCKER_EE_IMAGE

# dvp stage of Dockerfile
FROM $BASE_DOCKER_DVP_IMAGE

# iop stage of Dockerfile
FROM $BASE_DOCKER_IOP_IMAGE

# ee stage of Dockerfile
FROM $BASE_DOCKER_EE_IMAGE

# Second stage of Dockerfile