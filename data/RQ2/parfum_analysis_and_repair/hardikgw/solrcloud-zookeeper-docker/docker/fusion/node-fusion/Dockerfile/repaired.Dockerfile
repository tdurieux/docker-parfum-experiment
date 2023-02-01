FROM ubuntu:14.04
ENV\
	FUSION_VER=2.4.2
RUN \
	apt-get update && \
	apt-get install --no-install-recommends -y wget vim nodejs tar npm default-jdk && \
	apt-get update && \
	npm install -g gulp && \
	wget https://download.lucidworks.com/fusion-$FUSION_VER.tar.gz && \
	tar xzvf fusion-$FUSION_VER.tar.gz && npm cache clean --force; && rm fusion-$FUSION_VER.tar.gz && rm -rf /var/lib/apt/lists/*;
EXPOSE 3000 8764 8765 8983 8984 8766 8769