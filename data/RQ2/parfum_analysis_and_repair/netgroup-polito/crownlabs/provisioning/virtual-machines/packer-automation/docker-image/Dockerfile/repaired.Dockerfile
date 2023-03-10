FROM ubuntu:20.04
RUN apt-get update && DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get --no-install-recommends -y install apt-utils \
    gnupg2 \
    ca-certificates \
    curl \
    gnupg \
    lsb-release && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --batch --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get --no-install-recommends install -y docker-ce \
    docker-ce-cli \
    containerd.io && rm -rf /var/lib/apt/lists/*;


WORKDIR /images

ENV IMAGE_NAME=
ENV USERNAME=
ENV PASSWORD=

COPY script.sh /usr/src/script.sh

ENTRYPOINT [ "/usr/src/script.sh" ]