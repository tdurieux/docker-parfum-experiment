FROM node:alpine
RUN apk add --no-cache git nodejs npm openssh
RUN npm i -g pnpm && npm cache clean --force;
RUN git clone https://github.com/hackbg/fadroma /src
WORKDIR /src
RUN sed -i -e "s|git@github.com\:|https://github.com/|" .gitmodules
RUN git submodule update --init
RUN pnpm i
