FROM google/dart:latest

ARG FVM_VERSION

RUN apt-get update --quiet --yes && apt-get install --no-install-recommends --quiet --yes \
    unzip \
    apt-utils && rm -rf /var/lib/apt/lists/*;

RUN pub global activate fvm ${FVM_VERSION}
