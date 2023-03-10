FROM alpine:latest

MAINTAINER Jordi Guillaumes Pons <jg@jordi.guillaumes.name>

ENV SIMDIR "vde"
ENV RUNPKGS "net-tools vde2 vde2-libs libpcap nano readline openssh bash"

RUN apk --update --no-cache add $RUNPKGS && rm -rf /var/cache/apk/*

RUN apk --update --no-cache add $RUNPKGS && \
	rm -rf /var/cache/apk/*

RUN adduser -D vdeplug && \
    echo "vdeplug:vdeplug" | chpasswd

ENV PATH /simh-bin:$PATH

EXPOSE 7667/udp
EXPOSE 22/tcp

VOLUME /vde.ctl
VOLUME /vde.mgmt

COPY /$SIMDIR/startup.sh     /startup.sh

ENTRYPOINT ["/startup.sh"]
