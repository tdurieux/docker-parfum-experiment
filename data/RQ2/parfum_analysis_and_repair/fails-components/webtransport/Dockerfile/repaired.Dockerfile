FROM node:16-bullseye

ARG ENV

RUN apt-get update -y && apt-get upgrade -y && apt-get install --no-install-recommends -y clang-9 cmake build-essential perl6 golang ninja-build protobuf-compiler && rm -rf /var/lib/apt/lists/*;


WORKDIR /usr/src/webtransport

COPY package*.json ./

COPY . .


RUN npm install --production=false --unsafe-perm && npm cache clean --force;



#debug
RUN --mount=type=secret,id=GH_TOKEN export GH_TOKEN=`cat /run/secrets/GH_TOKEN`; if [ "$ENV" = "debug" ] ; then \
 npm install ; npm cache clean --force; else  npm ci --only=production; fi



EXPOSE 8080/udp

#CMD [ "node", "src/main.js" ]
