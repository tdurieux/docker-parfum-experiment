FROM golang as builder
RUN apt-get update && apt-get install --no-install-recommends -y upx && rm -rf /var/lib/apt/lists/*;
ADD . /luet
RUN cd /luet && make build

FROM scratch
ENV LUET_NOLOCK=true
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /luet/luet /usr/bin/luet

ENTRYPOINT ["/usr/bin/luet"]
