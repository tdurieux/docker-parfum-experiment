FROM ubuntu

# Installations
RUN apt-get update -qq && apt-get install --no-install-recommends -y curl git python-pip parallel jq wget && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir awscli
RUN curl -f https://nodejs.org/dist/v8.9.4/node-v8.9.4-linux-x64.tar.gz | tar zxC /usr/local --strip-components=1

# Setup watchbot for logging and env var decryption
RUN wget https://s3.amazonaws.com/watchbot-binaries/linux/v4.11.1/watchbot -O /usr/local/bin/watchbot
RUN chmod +x /usr/local/bin/watchbot
RUN npm install -g decrypt-kms-env@^2.0.1 && npm cache clean --force;

# Setup application directory
RUN mkdir -p /usr/local/src/ecs-conex
WORKDIR /usr/local/src/ecs-conex

ENV conex_docker_version "17.12.1"
RUN curl -f -sL https://download.docker.com/linux/static/stable/x86_64/docker-${conex_docker_version}-ce.tgz > docker-${conex_docker_version}-ce.tgz
RUN tar -xzf docker-${conex_docker_version}-ce.tgz && cp docker/docker /usr/local/bin/docker && chmod 755 /usr/local/bin/docker && rm docker-${conex_docker_version}-ce.tgz

# Copy files into the container
COPY ./*.sh ./

# Use docker on the host instead of running docker-in-docker
# https://jpetazzo.github.io/2015/09/03/do-not-use-docker-in-docker-for-ci/
VOLUME /var/run/docker.sock
