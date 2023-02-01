FROM ubuntu:18.04
MAINTAINER Mindaugas K. <kasp.mindaugas@gmail.com>

# Add dependencies
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y git git-core curl && \
    apt-get install --no-install-recommends -y nodejs && \
    apt-get install --no-install-recommends -y npm && \
    apt-get install --no-install-recommends -y build-essential ffmpeg python && \
    apt-get autoremove -y && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app
COPY . /usr/src/app
RUN npm install && npm cache clean --force;

CMD [ "npm", "run", "prod"]