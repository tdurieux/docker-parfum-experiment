FROM alpine:3.12

# libc6-compat & libstdc++ are required for extended SASS libraries
# ca-certificates are required to fetch outside resources (like Twitter oEmbeds)
RUN apk update && \
    apk add --no-cache ca-certificates libc6-compat libstdc++ git

RUN wget https://github.com/caddyserver/caddy/releases/download/v2.4.6/caddy_2.4.6_linux_amd64.tar.gz &&\
    tar -xzvf caddy_2.4.6_linux_amd64.tar.gz && \
    mv caddy /bin && rm caddy_2.4.6_linux_amd64.tar.gz

COPY docs/build/html /static
WORKDIR /static

EXPOSE 1313

CMD ["caddy", "file-server", "--listen", ":1313"]
