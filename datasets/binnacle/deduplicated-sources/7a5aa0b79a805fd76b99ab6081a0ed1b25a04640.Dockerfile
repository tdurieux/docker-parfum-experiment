FROM alpine:3.8

WORKDIR /app

COPY . /app
ENV GIN_MODE=release

CMD ./main $PORT
