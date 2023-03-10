ARG REPO=https://github.com/symphonyoss/SymphonyElectron.git
ARG BRANCH=main

FROM ubuntu:latest

ARG REPO
ARG BRANCH

MAINTAINER Kiran Niranjan<kiran.niranjan@symphony.com>

# Update
RUN apt-get update

# Install dependencies
RUN apt-get install --no-install-recommends -y \
    curl \
    git \
    gcc \
    g++ \
    make \
    build-essential \
    libssl-dev \
    libx11-dev \
    libxkbfile-dev \
    libxtst-dev \
    libpng-dev \
    zlib1g-dev \
    rpm && rm -rf /var/lib/apt/lists/*;

# install node
RUN curl -f -sL https://deb.nodesource.com/setup_12.x | bash
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# Clone specific branch and repo
RUN echo ${BRANCH} ${REPO}
RUN git clone -b ${BRANCH} ${REPO}
WORKDIR SymphonyElectron
CMD ["chmod +x scripts/build-linux.sh"]
CMD ["sh", "scripts/build-linux.sh"]
