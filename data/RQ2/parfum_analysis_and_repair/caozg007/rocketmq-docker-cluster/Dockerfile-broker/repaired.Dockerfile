FROM java:alpine
MAINTAINER caozg007
WORKDIR /opt
COPY broker-entrypoint.sh  broker-entrypoint.sh
COPY clusterlist.sh clusterlist.sh
ADD bin bin
ADD conf conf
ADD lib lib
ADD broker.properties broker.properties
RUN mkdir -p /root/logs/rocketmqlogs && touch /root/logs/rocketmqlogs/broker.log
VOLUME ["/opt"]
ENTRYPOINT ["/bin/sh","broker-entrypoint.sh"]
HEALTHCHECK --interval=5s --timeout=3s CMD status=`netstat -an | grep -wi listen | grep 10911 | wc -l`;if [ $status eq 1 ]; then echo "0"; else echo "1"; fi