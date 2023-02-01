####################################
#   Multi-stage build
#       1. build oltpbench
#       2. run oltpbench client
####################################

# Stage 1 - Build oltpbench

FROM maven:3-jdk-11 as benchmark-builder

LABEL maintainer="tjveil@gmail.com"

ARG GIT_BRANCH=maven

RUN mkdir -v /opt/oltpbench \
    && git clone https://github.com/timveil-cockroach/oltpbench.git /opt/oltpbench \
    && cd /opt/oltpbench \
    && git checkout -f ${GIT_BRANCH} \
    && mvn clean package -DskipTests=true


# Stage 2 - run oltpbench client