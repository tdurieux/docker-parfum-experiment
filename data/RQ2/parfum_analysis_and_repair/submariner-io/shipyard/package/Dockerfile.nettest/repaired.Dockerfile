FROM alpine

WORKDIR /app

RUN apk add --update --no-cache gcc libc-dev make curl automake autoconf

RUN curl -f -L https://github.com/HewlettPackard/netperf/archive/netperf-2.7.0.tar.gz | tar xzf -
RUN cd netperf-netperf-2.7.0 \
    && aclocal -I src/missing/m4 && automake --add-missing --force-missing && autoconf && autoheader \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" CFLAGS=-fcommon \
    && make && make install


FROM alpine

WORKDIR /app

RUN apk add --no-cache \
	bash \
	bind-tools \
	curl \
	iputils \
	iperf3 \
	tcpdump

COPY --from=0 /usr/local/bin/net* /usr/local/bin/
COPY scripts/nettest/* /app/

CMD ["/bin/bash","-l"]
