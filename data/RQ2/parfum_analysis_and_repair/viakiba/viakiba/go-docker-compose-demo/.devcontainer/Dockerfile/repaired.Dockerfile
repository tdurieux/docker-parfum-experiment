FROM golang:1.18.3-bullseye
# Configure to reduce warnings and limitations as instruction from official VSCode Remote-Containers.
# See https://code.visualstudio.com/docs/remote/containers-advanced#_reducing-dockerfile-build-warnings.
RUN apt-get update && apt-get -y --no-install-recommends install git iproute2 procps lsb-release && rm -rf /var/lib/apt/lists/*; ENV DEBIAN_FRONTEND=noninteractive
