FROM alpine:3.4

COPY . .

RUN apk update && apk add --no-cache perl curl wget make && curl -f -L https://cpanmin.us | perl - App::cpanminus && cpanm Mojolicious Chess::Rep Try::Tiny

EXPOSE 3001

CMD ["perl", "./mock-autopatzerd", "daemon"]
