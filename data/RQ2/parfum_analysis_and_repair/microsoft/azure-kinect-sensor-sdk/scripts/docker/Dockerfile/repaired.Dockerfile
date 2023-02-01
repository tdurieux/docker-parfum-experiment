ARG UBUNTU_VERSION=18.04
# Use the official ubuntu:18.04 image as the parent image
FROM ubuntu:${UBUNTU_VERSION}

# Set the working directory to /app
WORKDIR /app

ARG ARCH=amd64

ADD setup-ubuntu.sh /app
ADD sources.list /app

# Tell Ubuntu non-interactive install
ARG DEBIAN_FRONTEND=noninteractive


RUN ./setup-ubuntu.sh ${ARCH}

RUN apt-get install --no-install-recommends -y ca-certificates && rm -rf /var/lib/apt/lists/*;
RUN update-ca-certificates