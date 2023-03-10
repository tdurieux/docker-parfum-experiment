FROM alpine:3.14
RUN apk add --no-cache exiftool>12.06-r0

WORKDIR /app
COPY photofield ./

RUN mkdir ./data && touch ./data/configuration.yaml

EXPOSE 8080
ENV PHOTOFIELD_DATA_DIR=./data
ENTRYPOINT ["./photofield"]