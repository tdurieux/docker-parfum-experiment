FROM alpine:3.6

RUN apk --update --no-cache add git openssh && \
  rm -rf /var/lib/apt/lists/* && \
  rm /var/cache/apk/*

ENTRYPOINT ["git"]
CMD ["--help"]