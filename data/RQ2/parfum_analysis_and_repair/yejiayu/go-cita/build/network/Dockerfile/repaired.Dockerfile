FROM alpine:3.8

LABEL maintainer="Jiayu Ye <yejiayu.fe@gmail.com>"

COPY bin/network /network

ENTRYPOINT ["/network"]