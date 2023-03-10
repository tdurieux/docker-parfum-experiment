FROM ekidd/rust-musl-builder as builder

RUN curl -f -L -o monolith.tar.gz $( curl -f -s https://api.github.com/repos/y2z/monolith/releases/latest \
                                 | grep "tarball_url.*\"," \
                                 | cut -d '"' -f 4)
RUN tar xfz monolith.tar.gz \
    && mv Y2Z-monolith-* monolith \
    && rm monolith.tar.gz

WORKDIR monolith/
RUN make install


FROM alpine

RUN apk update && \
  apk add --no-cache openssl && \
  rm -rf "/var/cache/apk/*"

COPY --from=builder /home/rust/.cargo/bin/monolith /usr/bin/monolith
WORKDIR /tmp
ENTRYPOINT ["/usr/bin/monolith"]
