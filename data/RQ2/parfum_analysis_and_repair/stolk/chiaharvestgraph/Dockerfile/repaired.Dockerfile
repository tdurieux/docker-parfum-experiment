FROM alpine/make
RUN apk add --no-cache build-base

COPY . .
RUN make
ENTRYPOINT ./chiaharvestgraph /.chia/mainnet/log
