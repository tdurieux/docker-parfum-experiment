FROM harbor.disembark.dev/libs/libwebp:latest as libwebp

FROM harbor.disembark.dev/libs/libavif:latest as libavif

FROM harbor.disembark.dev/libs/gifsicle:latest as gifsicle

FROM harbor.disembark.dev/libs/gifski:latest as gifski

FROM golang:1.18 AS builder

WORKDIR /tmp/app

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y git libwebp-dev build-essential

COPY . .

RUN go install github.com/gobuffalo/packr/v2/packr2@latest && packr2 && go build -o seventv

FROM harbor.disembark.dev/libs/ffmpeg:latest

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y webp optipng libvips-tools && apt-get clean

COPY --from=libwebp /libwebp/cwebp /usr/bin
COPY --from=libwebp /libwebp/dwebp /usr/bin
COPY --from=libwebp /libwebp/webpmux /usr/bin
COPY --from=libwebp /libwebp/img2webp /usr/bin
COPY --from=libwebp /libwebp/anim_dump /usr/bin

COPY --from=libavif /libavif/avifdump /usr/bin
COPY --from=libavif /libavif/avifdec /usr/bin
COPY --from=libavif /libavif/avifenc /usr/bin

COPY --from=gifsicle /gifsicle/gifsicle /usr/bin
COPY --from=gifski /gifski/target/release/gifski /usr/bin

WORKDIR /app

COPY --from=builder /tmp/app/seventv .

ENTRYPOINT ["./seventv"]
