FROM python:3.7.8

RUN pip install --no-cache-dir --upgrade pip

# Node install start

RUN groupadd --gid 1000 node \
  && useradd --uid 1000 --gid node --shell /bin/bash --create-home node

RUN apt update && apt --no-install-recommends -y install curl python3-pip \
  && curl -f -sL https://deb.nodesource.com/setup_14.x -o nodesource_setup.sh \
  && bash nodesource_setup.sh \
  && apt-get update \
  && apt --no-install-recommends -y install nodejs \
  && ln -s /usr/local/bin/node /usr/local/bin/nodejs \
  && rm -rf /var/lib/apt/lists/*

ADD . /server
WORKDIR /server
RUN npm i --production && npm cache clean --force;
CMD ["node", "/server/index.js"]
