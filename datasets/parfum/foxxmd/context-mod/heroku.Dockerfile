FROM node:16-alpine3.14

ENV TZ=Etc/GMT

# vips required to run sharp library for image comparison
RUN echo "http://dl-4.alpinelinux.org/alpine/v3.14/community" >> /etc/apk/repositories \
    && apk --update add vips

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

WORKDIR /usr/app

COPY package*.json ./
COPY tsconfig.json .

RUN npm install

ADD . /usr/app

RUN npm run build

ENV NPM_CONFIG_LOGLEVEL debug

ARG log_dir=/home/node/logs
RUN mkdir -p $log_dir
VOLUME $log_dir
ENV LOG_DIR=$log_dir

CMD [ "node", "src/index.js", "run", "all",  "--port $PORT"]
