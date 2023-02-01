FROM alpine  
MAINTAINER Anastas Dancha <anapsix@random.io>  
  
ENV WEBDIS_REPO https://github.com/nicolasff/webdis.git  
  
RUN apk upgrade --update && \  
apk add alpine-sdk libevent-dev bsd-compat-headers git && \  
git clone \--depth 1 $WEBDIS_REPO /tmp/webdis && \  
cd /tmp/webdis && make clean all && \  
sed -i '/redis_host/s/"127.*"/"redis"/g' webdis.json && \  
cp webdis /usr/local/bin/ && \  
cp webdis.json /etc/ && \  
mkdir -p /usr/share/doc/webdis && \  
cp README.markdown /usr/share/doc/webdis/README && \  
cd /tmp && rm -rf /tmp/webdis && \  
apk del --purge alpine-sdk libevent-dev bsd-compat-headers git && \  
apk add libevent  
  
ADD docker-entrypoint.sh /entrypoint.sh  
ENTRYPOINT ["/entrypoint.sh"]  
  
EXPOSE 7379  

