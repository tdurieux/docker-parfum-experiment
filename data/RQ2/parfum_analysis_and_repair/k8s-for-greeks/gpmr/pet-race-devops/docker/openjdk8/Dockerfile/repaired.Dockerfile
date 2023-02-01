FROM alpine:3.4

RUN apk --update --no-cache add openjdk8
CMD ["/usr/bin/java", "-version"]
