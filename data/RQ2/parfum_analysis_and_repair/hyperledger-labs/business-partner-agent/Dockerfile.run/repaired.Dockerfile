# Dockerfile that only runs the backend (with or without frontend), mainly used within the build pipeline

FROM eclipse-temurin:17-jre-focal

RUN adduser --disabled-password app

WORKDIR /home/app

# Setup rights for overwriting frontend runtime variables
COPY ./frontend/setup-runtime.sh setup-runtime.sh

RUN \
    mkdir public && \
    chmod a+x ./setup-runtime.sh && \
    chmod -R a+rw ./public

# Non-root