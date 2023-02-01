FROM alpine
RUN apk update && apk add --no-cache vim
ENTRYPOINT ["vim"]
