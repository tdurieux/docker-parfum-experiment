# to run:
#
# docker run --net host -it \
#   -v /var/lib/zerotier-one/authtoken.secret:/authtoken.secret \
#   -v <token file>:/token.txt \
#   zeronsd:alpine start -s /authtoken.secret -t /token.txt \
#   <network id>

FROM alpine:latest as builder

RUN apk add --no-cache gcc
RUN apk add --no-cache libgcc
RUN apk add --no-cache musl-dev
RUN apk add --no-cache openssl
RUN apk add --no-cache openssl-dev
RUN apk add --no-cache curl

RUN curl -f -sSL sh.rustup.rs >/usr/local/bin/rustup-dl && chmod +x /usr/local/bin/rustup-dl && /usr/local/bin/rustup-dl -y --default-toolchain stable

COPY . /zeronsd
WORKDIR /zeronsd

ENV PATH=/root/.cargo/bin:${PATH}
RUN . /root/.cargo/env && cargo install --path .

FROM alpine:latest

RUN apk add --no-cache openssl ca-certificates libgcc

COPY --from=builder /root/.cargo/bin/zeronsd /bin/zeronsd

ENTRYPOINT ["zeronsd"]
