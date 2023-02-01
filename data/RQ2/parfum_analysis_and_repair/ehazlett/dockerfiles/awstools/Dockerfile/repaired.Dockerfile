FROM alpine:latest
RUN apk add --no-cache -U python py-pip groff && \
    pip install --no-cache-dir awscli
ENTRYPOINT ["/usr/bin/aws"]
CMD ["help"]
