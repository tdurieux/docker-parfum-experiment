FROM alpine
RUN apk update && apk add --no-cache curl
COPY doit.sh /
ENTRYPOINT ["sh","/doit.sh"]
