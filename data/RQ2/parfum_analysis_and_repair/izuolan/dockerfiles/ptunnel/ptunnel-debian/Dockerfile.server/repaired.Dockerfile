FROM debian:jessie
RUN apt-get update && \
    apt-get install --no-install-recommends ptunnel -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;
#ENV PASSWD=password
# EXPOSE 8000
ENTRYPOINT ["/usr/sbin/ptunnel"]
