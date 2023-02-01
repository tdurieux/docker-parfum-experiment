FROM node:14-alpine

WORKDIR /root

COPY run.sh ./

RUN apk add --no-cache tzdata

RUN chmod +x /root/run.sh && yarn global add dmhy-subscribe && yarn cache clean;

CMD /root/run.sh
