FROM scratch
MAINTAINER MinIO Development "dev@min.io"
EXPOSE 8080
COPY sidekick /sidekick
ENTRYPOINT ["/sidekick"]