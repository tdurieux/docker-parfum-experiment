FROM ubuntu:20.04

LABEL version="1.0"
LABEL description="Docker image for ncdump-json."

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
	apt-get install --no-install-recommends wget unzip build-essential cmake pkg-config libnetcdf-dev -y && \
	wget https://github.com/jllodra/ncdump-json/archive/master.zip && \
	unzip master.zip && \
	cd ncdump-json-master && \
	cmake . && \
	make && rm -rf /var/lib/apt/lists/*;

WORKDIR /ncdump-json-master

ENTRYPOINT ["./ncdump-json"]
