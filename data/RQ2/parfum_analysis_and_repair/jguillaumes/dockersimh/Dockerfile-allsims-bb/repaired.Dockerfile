FROM busybox:glibc

MAINTAINER Jordi Guillaumes Pons <jg@jordi.guillaumes.name>

ENV BUILDPKGS "git gcc libc-dev make vde2-dev libpcap-dev linux-headers readline-dev"
ENV RUNPKGS "net-tools vde2 vde2-libs libpcap nano readline bash"

RUN apt-get update && apt-get install -y --no-install-recommends $RUNPKGS && rm -rf /var/lib/apt/lists/*;

WORKDIR /workdir

RUN apt-get update && apt-get install -y --no-install-recommends $BUILDPKGS && \
	git clone git://github.com/simh/simh.git && \
	cd simh && \
	sed -e "s/\$(error Retry your build without specifying USE_NETWORK=1)/# SUPRESSED /g" makefile > makefile2 && \
	make LIBPATH=/usr/lib INCPATH=/usr/include USE_NETWORK=1 -f makefile2 && \
	mkdir /simh-bin && cp BIN/* /simh-bin && \
	apt-get remove $BULDPKGS && \
	rm -rf /workdir && \
	rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/*;

ENV PATH /simh-bin:$PATH

EXPOSE 2323-2326

VOLUME /machines
WORKDIR /machines

ENTRYPOINT ["busybox", "sh"]
