FROM ubuntu:bionic

# Improve build times by sharing this step with the other container
RUN apt-get update && apt-get install --no-install-recommends -y libev4 libudns0 && apt-get purge && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends -y git build-essential libudns-dev libpcre3 libpcre3-dev libev-dev devscripts automake libtool autoconf autotools-dev cdbs debhelper dh-autoreconf dpkg-dev gettext pkg-config fakeroot && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/dlundquist/sniproxy.git
WORKDIR /sniproxy
RUN ./autogen.sh && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make



FROM ubuntu:bionic
RUN apt-get update && apt-get install --no-install-recommends -y libev4 libudns0 && apt-get purge && rm -rf /var/lib/apt/lists/*;
COPY --from=0  /sniproxy/src/sniproxy /usr/local/bin/sniproxy
ADD sniproxy.conf /etc/sniproxy.conf
CMD sniproxy -f
