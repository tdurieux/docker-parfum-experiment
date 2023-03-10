FROM java:alpine
MAINTAINER caozg007
WORKDIR /opt
COPY nameserver-entrypoint.sh  nameserver-entrypoint.sh
COPY bin bin
COPY conf conf
COPY lib lib
RUN mkdir -p /root/logs/rocketmqlogs && touch /root/logs/rocketmqlogs/namesrv.log
VOLUME ["/opt"]
ENTRYPOINT ["/bin/sh","/nameserver-entrypoint.sh"]
HEALTHCHECK --interval=5s --timeout=3s CMD status=`netstat -an | grep -wi listen | grep 9876 | wc -l`;if [ $status eq 1 ]; then echo "0"; else echo "1"; fi