FROM alpine:3.9
LABEL Olivier Bonnaure <olivier@solisoft.net>

RUN apk update && apk upgrade

RUN apk --no-cache add --virtual native-deps \
  nodejs npm g++ gcc libgcc libstdc++ linux-headers make python bash ffmpeg && \
  npm config set unsafe-perm true && \
  npm install --quiet yarn -g && \
  npm install --quiet nodemon -g && npm cache clean --force;

RUN apk add --no-cache vips-dev fftw-dev build-base --update-cache \
    --repository https://alpine.global.ssl.fastly.net/alpine/edge/community/ \
    --repository https://alpine.global.ssl.fastly.net/alpine/edge/main



RUN mkdir /workspace

WORKDIR /workspace