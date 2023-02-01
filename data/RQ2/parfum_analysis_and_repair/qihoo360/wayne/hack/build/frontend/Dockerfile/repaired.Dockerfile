# requiring Docker 17.05 or higher on the daemon and client
# see https://docs.docker.com/develop/develop-images/multistage-build/
# BUILD COMMAND :
# docker --build-arg RELEASE_VERSION=v1.0.0 -t infra/wayne:v1.0.0 .

# build ui
FROM 360cloud/wayne-ui-builder:v1.0.2 as frontend

COPY src/frontend /workspace

RUN cd /workspace && \
    npm run build:aot

# build server