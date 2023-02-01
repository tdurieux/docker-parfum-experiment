FROM node:16.1.0

RUN apt-get update && \
  apt-get install --no-install-recommends -y vim chromium && rm -rf /var/lib/apt/lists/*;

WORKDIR /code/

ADD .babelrc tsconfig.json package.json package-lock.json webpack.config.js /code/

RUN npm install && npm cache clean --force;

ADD examples /code/examples
ADD scripts /code/scripts/
ADD packages /code/packages/
ADD test /code/test

RUN npm install && npm run build && npm cache clean --force;

ENTRYPOINT "/bin/sh"
