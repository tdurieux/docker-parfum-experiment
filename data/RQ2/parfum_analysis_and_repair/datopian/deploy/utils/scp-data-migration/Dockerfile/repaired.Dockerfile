FROM alpine:3.7
RUN apk update && apk add --no-cache openssh-client bash
COPY entrypoint.sh /
ENTRYPOINT ["bash", "/entrypoint.sh"]
