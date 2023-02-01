FROM ubuntu:18.04
MAINTAINER Sergio Padrino (@sergiou87)

RUN apt-get update \
	&& apt-get --assume-yes -y --no-install-recommends install make git-core cmake python curl sudo wget \
    && git clone https://github.com/vitasdk/vdpm \
    && cd vdpm \
	&& export VITASDK=/usr/local/vitasdk \
	&& export PATH=$VITASDK/bin:$PATH \
    && ./bootstrap-vitasdk.sh \
	&& ./install-all.sh && rm -rf /var/lib/apt/lists/*;

WORKDIR /src
CMD ["/bin/ash"]
