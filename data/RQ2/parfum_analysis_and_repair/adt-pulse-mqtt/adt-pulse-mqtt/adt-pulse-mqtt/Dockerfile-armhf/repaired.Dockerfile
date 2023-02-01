ARG BUILD_FROM=balenalib/armv7hf-alpine:3.13-run
FROM $BUILD_FROM

ENV LANG C.UTF-8
ENV NODE_ENV production
ENV QEMU_EXECVE 1

RUN [ "cross-build-start" ]

# Install node and npm (Node 14 LTS)
RUN apk add --no-cache --update nodejs=~14
RUN apk add --no-cache --update npm=~14

WORKDIR /usr/src/app

# Install app dependencies
COPY package.json .
RUN /usr/bin/npm install

# Bundle app source
COPY . .

# Copy data for add-on
COPY run.sh /
RUN chmod a+x /run.sh 

RUN [ "cross-build-end" ]

CMD [ "/run.sh" ]
