FROM mhart/alpine-node:4
RUN apk update
RUN apk add --no-cache --update procps
RUN apk add --no-cache --update git
RUN apk add --no-cache --update curl
RUN rm -rf /var/cache/apk/*

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY package.json /usr/src/app/
COPY . /usr/src/app
RUN npm install -g && npm cache clean --force;

COPY ./run.sh /run.sh
RUN chmod +x /run.sh
EXPOSE 9000
CMD /run.sh
