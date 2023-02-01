FROM node:8-alpine

WORKDIR /root/

ADD . /root/sentinel

ADD run.sh /root/

RUN npm install nodemon -g && apk update && apk upgrade && apk add --no-cache bash g++ gcc gmp-dev libffi-dev make python2 python3 redis nano git && npm cache clean --force;

CMD [ "sh", "run.sh" ]

EXPOSE 3000
