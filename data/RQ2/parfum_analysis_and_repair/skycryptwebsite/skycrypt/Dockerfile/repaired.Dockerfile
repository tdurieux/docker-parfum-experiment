FROM node:current-slim
LABEL maintainer="SkyCrypt"
RUN mkdir -p /usr/src/main && rm -rf /usr/src/main
WORKDIR '/usr/src/main'
COPY . /usr/src/main
RUN npm ci && npm build
EXPOSE 32464
