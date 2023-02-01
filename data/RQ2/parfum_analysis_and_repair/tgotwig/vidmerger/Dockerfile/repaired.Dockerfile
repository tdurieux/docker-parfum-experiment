FROM alpine

RUN apk add --no-cache ffmpeg

COPY target/x86_64-unknown-linux-musl/release/vidmerger /

CMD ./vidmerger data/
