FROM alpine:latest
RUN apk add rust cargo git cmake make g++ pango-dev fontconfig-dev libxinerama-dev libxfixes-dev libxcursor-dev
COPY . .
RUN cargo build
CMD ["echo", "Done building!"]
