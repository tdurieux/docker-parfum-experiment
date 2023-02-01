FROM ubuntu:latest

ARG PYATV_VERSION=0.9.2
ARG NODE_VERSION=14

# ensure local python is preferred over distribution python
ENV PATH /usr/local/bin:$PATH

RUN apt-get update && \
    apt-get install --no-install-recommends -y python3-dev python3-pip curl sudo && \
    pip3 install --no-cache-dir pyatv~=${PYATV_VERSION} && \
    curl -f -sL https://deb.nodesource.com/setup_${NODE_VERSION}.x | sudo -E bash - && \
    sudo apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

COPY package*.json "/app/"
WORKDIR "/app"
RUN npm ci

COPY . "/app/"
CMD ["npm", "run", "test"]
