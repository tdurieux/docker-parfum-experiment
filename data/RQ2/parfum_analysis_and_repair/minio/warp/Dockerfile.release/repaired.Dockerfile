FROM alpine
MAINTAINER MinIO Development "dev@min.io"
EXPOSE 7761
COPY warp /warp

ENTRYPOINT ["/warp"]