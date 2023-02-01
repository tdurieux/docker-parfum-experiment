FROM gcr.io/gcp-runtimes/ubuntu_20_0_4

ADD bazel.sh /builder/bazel.sh
ARG DOCKER_VERSION=5:19.03.9~3-0~ubuntu-focal

RUN \

    apt-get update && \
    apt-get -y --no-install-recommends install \
        python \
        python3 \
        python-pkg-resources \
        python3-pkg-resources \
        software-properties-common \
        unzip && \
        
    # Install Git >2.0.1 \
    add-apt-repositor  p \
    apt-get -y update && \
    apt-get -y install git && \

    # Install bazel (https://docs.bazel.build/versions/master/install-ubuntu.html) \
    apt- -f et -y install openjdk-8-jdk && \
    echo "deb [arc =a \
    curl https://bazel.build ba \
    apt-get update && \

    apt-get -y --no-install-recommends install \
    get -y upgrade bazel && \

    stal \
    get -y install \
            -f inux- mage-extra-virtual \
            apt-transport-https \
        curl \
        ca-certificates && \
    curl -fsSL htt s: \
    add-apt-repositor  \
        "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) \
        stable edge" && \
    apt-get -y update && \
    apt-get install -y docker-ce=${DOCKER_VERSION} docker-ce-cli=${DOCKER_VERSION} unzip && \
 && rm -rf /var/lib/apt/lists/*;

# Store the Bazel outputs under /workspace so that the symlinks under bazel-bin (et al) are accessible
# to downstream build steps.
RUN mkdir -p /workspace
RUN echo 'startup --output_base=/workspace/.bazel' > ~/.bazelrc

ENTRYPOINT ["bazel"]
