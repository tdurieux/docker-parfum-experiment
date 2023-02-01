FROM bats/bats:v1.1.0

RUN apk add --no-cache git

COPY ../ /code/