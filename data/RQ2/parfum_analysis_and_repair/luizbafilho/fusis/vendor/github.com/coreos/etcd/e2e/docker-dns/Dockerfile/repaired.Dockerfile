FROM golang:1.9.1-stretch
LABEL Description="Image for etcd DNS testing"

RUN apt update -y \
  && apt install --no-install-recommends -y -q \
  bind9 \
  dnsutils && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /var/bind /etc/bind
RUN chown root:bind /var/bind /etc/bind
ADD Procfile.tls /Procfile.tls
ADD run.sh /run.sh

ADD named.conf etcd.zone rdns.zone /etc/bind/
RUN chown root:bind /etc/bind/named.conf /etc/bind/etcd.zone /etc/bind/rdns.zone
ADD resolv.conf /etc/resolv.conf

RUN go get github.com/mattn/goreman
CMD ["/run.sh"]