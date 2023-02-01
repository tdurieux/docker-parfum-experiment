FROM ubuntu

RUN apt update && \
	apt install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN mkdir /tools
COPY docker-extract /tools/
