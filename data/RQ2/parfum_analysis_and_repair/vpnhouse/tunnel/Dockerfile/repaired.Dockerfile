FROM golang:1.17.6-alpine3.15 as toolset

RUN apk add --no-cache gcc make git musl-dev


FROM node:16-alpine3.14 as nodejs

COPY ./frontend /app/
WORKDIR /app
RUN npm install && npm run build && npm cache clean --force;


FROM toolset as builder

COPY . /build
COPY --from=nodejs /app/dist /build/internal/frontend/dist/
WORKDIR /build
RUN make build/app


FROM alpine:3.15

RUN apk add --no-cache tcpdump wireguard-tools nftables
COPY --from=builder /build/tunnel-node /tunnel-node
CMD ["/tunnel-node"]
