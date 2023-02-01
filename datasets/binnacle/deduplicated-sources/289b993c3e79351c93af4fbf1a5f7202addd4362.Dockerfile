# Docker build usage:
# 	docker build . -t opensdsio/opensds-apiserver:latest
# Docker run usage:
# 	docker run -d --net=host -v /etc/opensds:/etc/opensds opensdsio/opensds-apiserver:latest

FROM ubuntu:16.04
MAINTAINER Leon Wang <wanghui71leon@gmail.com>

COPY osdsapiserver /usr/bin

# Define default command.
CMD ["/usr/bin/osdsapiserver"]
