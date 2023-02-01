FROM ubuntu:16.04

RUN apt-get update && apt-get install --no-install-recommends -q -y automake autotools-dev fuse g++ git libcurl4-openssl-dev libfuse-dev libssl-dev libxml2-dev make pkg-config && rm -rf /var/lib/apt/lists/*;

ADD  compile-s3fs.sh /root
RUN  chmod 755 /root/compile-s3fs.sh

WORKDIR /root/

CMD ["/root/compile-s3fs.sh"]
