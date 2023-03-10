FROM mongo:latest

MAINTAINER Mahmoud Zalt <mahmoud@zalt.me>

#COPY mongo.conf /usr/local/etc/mongo/mongo.conf

COPY mongo.sh /mongo.sh

VOLUME /data/db /data/configdb

CMD ["mongod"]

EXPOSE 27017