FROM ubuntu:trusty

ENV LANG en_US.UTF-8
RUN locale-gen $LANG

RUN apt-get update -q && \
    apt-get install --no-install-recommends -qy build-essential libperl-dev libssl-dev && rm -rf /var/lib/apt/lists/*;

ADD http://znc.in/releases/znc-latest.tar.gz /tmp/znc.tar.gz
RUN tar xf /tmp/znc.tar.gz && \
    rm /tmp/znc.tar.gz && \
    mv /znc-* /tmp/znc

# Push module (https://github.com/jreese/znc-push)
ADD https://raw.github.com/jreese/znc-push/master/push.cpp /tmp/znc/modules/push.cpp
# Colloquy push modules (https://github.com/wired/colloquypush)
ADD https://raw.github.com/wired/colloquypush/master/znc/colloquy.cpp /tmp/znc/modules/colloquy.cpp

RUN cd /tmp/znc && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
    make && \
    make install && \
    rm -rf /tmp/znc
RUN useradd --system --user-group znc

ADD znc.conf /znc.conf.default
ADD start.sh /start.sh

VOLUME ["/data"]
EXPOSE 6667

CMD ["/start.sh"]
