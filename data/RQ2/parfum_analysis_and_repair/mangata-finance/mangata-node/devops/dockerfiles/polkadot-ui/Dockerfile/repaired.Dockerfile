from ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -y update && apt-get -y --no-install-recommends install npm curl git make && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_16.x -o /tmp/nodesource_setup.sh
RUN /bin/bash /tmp/nodesource_setup.sh
RUN apt-get -y update && apt-get -y --no-install-recommends install nodejs && rm -rf /var/lib/apt/lists/*;
RUN npm install -g yarn && npm cache clean --force;
RUN mkdir /code
ENV HOME=/tmp
RUN git clone https://github.com/polkadot-js/apps -b v0.96.1 /tmp/apps
WORKDIR /tmp/apps
RUN yarn install && yarn cache clean;
ENTRYPOINT yarn run start
