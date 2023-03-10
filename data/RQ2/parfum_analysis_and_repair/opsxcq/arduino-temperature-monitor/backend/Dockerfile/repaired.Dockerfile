FROM node:7.8.0

LABEL maintainer "opsxcq@strm.sh"

WORKDIR /src

COPY package.json /src

RUN npm install && npm cache clean --force;

COPY *.js /src/

EXPOSE 8080

ENTRYPOINT ["npm"]
CMD ["start"]
