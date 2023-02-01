FROM mhart/alpine-node:12

RUN npm install natsboard -g && npm cache clean --force;
RUN apk add --no-cache netcat-openbsd
COPY wait-for.sh /wait-for.sh
ENTRYPOINT ["/wait-for.sh"]
