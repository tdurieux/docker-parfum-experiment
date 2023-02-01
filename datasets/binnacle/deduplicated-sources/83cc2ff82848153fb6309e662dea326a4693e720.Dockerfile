FROM alpine@sha256:a1020e78cc1efca87cc3a4c78f1bef81c3db20e5283fa2c9a493de41d8933cc7
RUN \
	test "$(uname -m)" == "armv6l" && \
	apk add --no-cache bash g++ gcc git make nodejs python && \
	export MAKEFLAGS=-j8

RUN \
	apk add --no-cache npm
RUN \
	npm install storjshare-daemon
RUN \
	git clone https://github.com/calxibe/StorjMonitor.git /opt/StorjMonitor && \
	chmod +x /opt/StorjMonitor/storjMonitor.sh && \
	rm -rf /opt/StorjMonitor/node_modules && \
	npm --prefix /opt/StorjMonitor/ install && \
	npm cache clear --force
RUN \
	apk del --no-cache g++ gcc git make python

ENV USE_HOSTNAME_SUFFIX=FALSE \
	DATADIR=/storj \
	WALLET_ADDRESS= \
	SHARE_SIZE=1TB \
	RPCADDRESS=0.0.0.0 \
	RPCPORT=4000 \
	DAEMONADDRESS=127.0.0.1 \
	TUNNELING_REQUIRED=TRUE \
	STORJ_MONITOR_API_KEY=
EXPOSE 4000-4003/tcp

ADD versions entrypoint /
ENTRYPOINT ["/entrypoint"]
RUN \
	mv -i /node_modules/* /usr/lib/node_modules/ && \
	mv /node_modules/.bin/ /usr/lib/node_modules/ && \
	rmdir /node_modules
ENV PATH="$PATH:/usr/lib/node_modules/.bin"
