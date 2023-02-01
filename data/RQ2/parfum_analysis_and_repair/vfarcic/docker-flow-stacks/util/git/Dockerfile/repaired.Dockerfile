FROM alpine

RUN apk add --no-cache --update git

WORKDIR /repos

CMD ["git", "version"]