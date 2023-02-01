FROM docker.io/node:8

RUN apt-get update
RUN apt-get install --no-install-recommends -y mc && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y nano && rm -rf /var/lib/apt/lists/*;

RUN mkdir /frontend

ADD examples/frontend/package.json /frontend/
ADD . /frontend/

WORKDIR /frontend
RUN npm install && npm cache clean --force;
