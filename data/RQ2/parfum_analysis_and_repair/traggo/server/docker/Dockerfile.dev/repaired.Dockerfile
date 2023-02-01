FROM golang:1.18.1 as builder

RUN apt-get update && apt-get install --no-install-recommends --yes nodejs npm && npm install --global yarn && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

WORKDIR /app
COPY . .

ENV GO111MODULE=on
RUN make download-tools install generate build-bin-local

FROM scratch
WORKDIR /opt/traggo
COPY --from=builder /app/build/traggo-server /opt/traggo/traggo
EXPOSE 3030
ENTRYPOINT ["./traggo"]
