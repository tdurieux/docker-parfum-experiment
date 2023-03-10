FROM node:8-alpine
LABEL maintainer="spacemeowx2@gmail.com"

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories

RUN apk add --no-cache \
    build-base \
    g++ \
    cairo-dev \
    jpeg-dev \
    pango-dev \
    giflib-dev \
    tzdata \
    imagemagick

RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

RUN mkdir /code
WORKDIR /code
COPY ./package.json /code
RUN npm install --verbose && npm cache clean --force;

COPY . /code

CMD [ "npm", "run", "prod" ]
