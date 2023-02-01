FROM node:16.14

RUN apt-get update && \
  apt-get install --no-install-recommends -y lsof vim libgtk-3-0 libatk1.0-0 libx11-xcb1 libnss3 libxss1 libasound2 libdrm2 libgbm-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR /code/

ADD package-lock.json /code/package-lock.json
ADD package.json /code/package.json

RUN npm install && npm cache clean --force;

ADD ember-app-boilerplate /code/ember-app-boilerplate
ADD lib /code/lib
ADD test /code/test
ADD . /code/

ENTRYPOINT "/bin/bash"
