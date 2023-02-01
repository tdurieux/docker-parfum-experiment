FROM node:16-slim
LABEL maintainer="hello@wagtail.org"

RUN apt-get update && apt-get install --no-install-recommends rsync -y && rm -rf /var/lib/apt/lists/*;
COPY ./wagtail/package.json ./wagtail/package-lock.json ./

RUN npm --prefix / install --loglevel info && npm cache clean --force;
