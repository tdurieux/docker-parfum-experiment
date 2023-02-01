FROM ubuntu:trusty

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
	apt-get install --no-install-recommends -y \
		libcurl3 \
		libfuse2 \
		libgconf-2-4 \
		libglib2.0 \
		librtmp0 \
		libxss1 \
		openssl \
		wget && rm -rf /var/lib/apt/lists/*;

ADD Recipe /Recipe

VOLUME /out

ENTRYPOINT ["bash", "-ex", "/Recipe"]
