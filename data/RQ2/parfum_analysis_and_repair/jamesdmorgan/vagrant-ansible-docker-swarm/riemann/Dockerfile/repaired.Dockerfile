FROM sillelien/base-java
ENV RIEMANN_VERSION 0.2.11
RUN apk --update --no-cache add curl
WORKDIR /tmp
RUN curl -f -skL https://aphyr.com/riemann/riemann-${RIEMANN_VERSION}.tar.bz2 | bunzip2 | tar -x
RUN mkdir /opt
RUN mv riemann-${RIEMANN_VERSION} /opt/riemann
WORKDIR /opt/riemann
RUN sed -ie 's/env bash/env sh/' bin/riemann
ADD root /
EXPOSE 5555 5555/udp 5556
