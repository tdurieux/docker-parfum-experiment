FROM alpine:3.16

RUN apk add --no-cache containerd

ADD bundler.sh /bundler.sh
ADD image.list /image.list

CMD /bundler.sh
