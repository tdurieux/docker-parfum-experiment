FROM ubuntu:20.04

RUN apt-get update && apt-get install --no-install-recommends -y xinetd && rm -rf /var/lib/apt/lists/*;
RUN adduser --no-create-home --disabled-password --gecos "" vending
WORKDIR /vending
COPY vending .
COPY xinetd.conf /etc/xinetd.d/vending
CMD ["/usr/sbin/xinetd", "-dontfork"]
