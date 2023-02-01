FROM ubuntu:17.04
RUN apt-get update && apt-get -y --no-install-recommends install wget sudo python && rm -rf /var/lib/apt/lists/*;
COPY install_kth.sh /
RUN chmod 755 /install_kth.sh
RUN /install_kth.sh
RUN /kth/bin/bn --initchain
EXPOSE 8333
ENTRYPOINT ["/kth/bin/bn"]
