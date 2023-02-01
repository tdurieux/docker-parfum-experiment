FROM alpine:latest
RUN apk add --no-cache cargo && wget -O source.tar.gz $(wget -qO- https://api.github.com/repos/mbrubeck/agate/releases/latest | sed -nE 's/^.*"tarball_url"\s*:\s*"([^"]+)".*$/\1/p') && tar xzf source.tar.gz && mv /mbrubeck-agate-* /agate && cd agate && cargo build --release && rm source.tar.gz
RUN cp /agate/target/release/agate /usr/bin/agate
WORKDIR /app
COPY . /app
ADD . .
ENTRYPOINT ["/bin/sh", "start.sh"]

