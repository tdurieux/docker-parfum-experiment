FROM node:8.12.0

RUN apt-get update -y && apt-get install --no-install-recommends -y mongodb zip && rm -rf /var/lib/apt/lists/*;
RUN apt-get clean

WORKDIR /usr/bin
RUN curl -f -L "https://cli.run.pivotal.io/stable?release=linux64-binary&source=github" | tar -zx

ENV NPM_CONFIG_LOGLEVEL=warn
RUN npm install -g npm@4 && npm cache clean --force;
