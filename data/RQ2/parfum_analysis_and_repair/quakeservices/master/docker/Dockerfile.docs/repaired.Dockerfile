FROM quakeservices/cdk:latest

WORKDIR /code

COPY docs/package.json .
COPY docs/package-lock.json .

RUN --mount=type=cache,target=/root/.npm \
  npm install --global prettier && npm cache clean --force;
