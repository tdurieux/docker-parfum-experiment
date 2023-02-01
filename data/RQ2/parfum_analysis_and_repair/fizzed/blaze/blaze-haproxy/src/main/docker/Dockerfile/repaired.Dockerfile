FROM haproxy:2.1
COPY src/main/docker/haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg
#RUN mkdir /run
RUN mkdir /run/haproxy
RUN apt update && apt -y --no-install-recommends install socat && rm -rf /var/lib/apt/lists/*;