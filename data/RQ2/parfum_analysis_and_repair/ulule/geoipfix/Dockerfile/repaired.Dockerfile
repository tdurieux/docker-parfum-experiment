FROM debian:stretch-slim

RUN apt-get update \
	&& apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /usr/share/geoip \
	&& wget -O /tmp/GeoLite2-City.tar.gz https://geolite.maxmind.com/download/geoip/database/GeoLite2-City.tar.gz \
	&& tar xf /tmp/GeoLite2-City.tar.gz -C /usr/share/geoip --strip 1 \
	&& gzip /usr/share/geoip/GeoLite2-City.mmdb \
	&& ls -al /usr/share/geoip/ && rm /tmp/GeoLite2-City.tar.gz

ADD bin/geoipfix /geoipfix

CMD ["/geoipfix"]
