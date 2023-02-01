# DOCKER-VERSION 1.0.0

FROM ubuntu:14.04

# install nodejs and npm
RUN apt-get update
RUN apt-get install --no-install-recommends -y nodejs-legacy && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y npm && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

# install alsa and its deps
RUN apt-get install --no-install-recommends -y alsa && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libasound2-dev && rm -rf /var/lib/apt/lists/*;

# install douban.fm -g
RUN npm install douban.fm -g && npm cache clean --force;

CMD ["douban.fm"]