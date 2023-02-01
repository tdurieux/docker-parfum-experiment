FROM debian:8.1

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -qq update && apt-get -qq -y upgrade && apt-get -qq --no-install-recommends -y install default-jdk curl && rm -rf /var/lib/apt/lists/*;
ENV JAVA_HOME /usr/lib/jvm/default-java/jre

## 5555 - Riemann TCP and UDP; 5556 - Riemann websocket
EXPOSE 5555 5555/udp 5556
CMD ["/usr/bin/riemann"]

RUN curl -f -so /tmp/riemann.deb https://aphyr.com/riemann/riemann_0.2.10_all.deb && dpkg -i /tmp/riemann.deb && rm -f /tmp/riemann.deb
ADD riemann.config /etc/riemann/
