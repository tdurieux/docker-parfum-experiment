# Base Distro Arg
ARG LATEST_UBUNTU_VERSION

FROM ubuntu:$LATEST_UBUNTU_VERSION

# Build Args
ARG DOWNLOAD_URL

RUN apt-get -qq update && apt-get install --no-install-recommends -y python build-essential git curl && curl -f -sL https://deb.nodesource.com/setup_10.x | bash - && apt-get install --no-install-recommends -y docker.io docker-compose nodejs && rm -rf /var/lib/apt/lists/*;
RUN git clone $DOWNLOAD_URL /home

WORKDIR /home/DockerSecurityPlayground

RUN npm install && npm cache clean --force;

COPY . .

ENTRYPOINT ["/bin/bash", "./run.sh"]