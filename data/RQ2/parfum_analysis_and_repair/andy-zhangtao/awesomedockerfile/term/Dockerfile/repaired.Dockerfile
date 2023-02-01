FROM vikings/alpine
RUN apk add --no-cache ttyd openssh
ENTRYPOINT [ "ttyd","sh" ]