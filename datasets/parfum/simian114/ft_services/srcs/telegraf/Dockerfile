FROM alpine:latest

ENV TELEGRAF_VERSION 1.14.0

RUN	wget https://dl.influxdata.com/telegraf/releases/telegraf-${TELEGRAF_VERSION}-static_linux_amd64.tar.gz \
	&& tar -C . -xzf telegraf-${TELEGRAF_VERSION}-static_linux_amd64.tar.gz \
	&& chmod +x telegraf/telegraf \
	&& cp telegraf/telegraf /usr/bin/ \
	&& rm -rf telegraf-${TELEGRAF_VERSION}-static_linux_amd64.tar.gz telegraf/

ENTRYPOINT ["usr/bin/telegraf"]
