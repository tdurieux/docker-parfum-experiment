FROM alpine
RUN apk update
RUN apk add --no-cache -v iptables sudo
ADD bin/etcd-agent /
ADD bin/etcd /
ADD bin/etcd-tester /
RUN mkdir /failure_archive
CMD ["./etcd-agent", "-etcd-path", "./etcd"]
