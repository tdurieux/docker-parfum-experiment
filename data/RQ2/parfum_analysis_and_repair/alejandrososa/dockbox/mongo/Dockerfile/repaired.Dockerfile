FROM mongo:latest

MAINTAINER Alejandro Sosa <alesjohnson@hotmail.com>

#COPY mongo.conf /usr/local/etc/mongo/mongo.conf

VOLUME /data/db /data/configdb

CMD ["mongod"]

EXPOSE 27017