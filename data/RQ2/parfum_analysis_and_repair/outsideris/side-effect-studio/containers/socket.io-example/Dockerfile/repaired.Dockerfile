FROM node:0.10
MAINTAINER Outsider <outsideris@gmail.com>

COPY ./src/ /src
RUN cd /src; npm install && npm cache clean --force;

EXPOSE  3000

CMD ["/src/bin/express"]
