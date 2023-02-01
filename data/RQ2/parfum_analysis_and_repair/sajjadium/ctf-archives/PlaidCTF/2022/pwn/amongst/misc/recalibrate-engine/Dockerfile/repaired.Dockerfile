FROM ubuntu:20.04

RUN apt-get update && apt-get install --no-install-recommends -y xinetd && rm -rf /var/lib/apt/lists/*;
RUN adduser --no-create-home --disabled-password --gecos "" engine
WORKDIR /engine
COPY engine .
COPY xinetd.conf /etc/xinetd.d/engine
CMD ["/usr/sbin/xinetd", "-dontfork"]
