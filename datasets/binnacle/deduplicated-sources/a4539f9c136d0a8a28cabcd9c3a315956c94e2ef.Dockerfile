FROM debian:jessie  
MAINTAINER Devops <devops@sprucefinance.com>  
  
ENV DANTE_VER 1.4.2  
ENV DANTE_URL https://www.inet.no/dante/files/dante-$DANTE_VER.tar.gz  
ENV DANTE_SHA baa25750633a7f9f37467ee43afdf7a95c80274394eddd7dcd4e1542aa75caad  
ENV DANTE_FILE dante.tar.gz  
ENV DANTE_TEMP dante  
ENV DANTE_DEPS build-essential curl  
  
RUN set -xe \  
&& apt-get update \  
&& apt-get install -y $DANTE_DEPS \  
&& mkdir $DANTE_TEMP \  
&& cd $DANTE_TEMP \  
&& curl -sSL $DANTE_URL -o $DANTE_FILE \  
&& echo "$DANTE_SHA *$DANTE_FILE" | shasum -c \  
&& tar xzf $DANTE_FILE \--strip 1 \  
&& ./configure \  
&& make install \  
&& cd .. \  
&& rm -rf $DANTE_TEMP \  
&& apt-get purge -y --auto-remove $DANTE_DEPS \  
&& rm -rf /var/lib/apt/lists/*  
  
COPY sockd.conf /etc/sockd.conf  
COPY entrypoint.sh /entrypoint.sh  
  
ENV CFGFILE /etc/sockd.conf  
ENV PIDFILE /tmp/sockd.pid  
ENV WORKERS 10  
EXPOSE 1080  
ENTRYPOINT /entrypoint.sh  
CMD sockd -f $CFGFILE -p $PIDFILE -N $WORKERS  
  

