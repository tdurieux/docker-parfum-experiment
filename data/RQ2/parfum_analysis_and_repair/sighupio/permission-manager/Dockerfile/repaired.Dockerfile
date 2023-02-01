# this docker file is used for the release
FROM golang:1.16 as builder

WORKDIR /app
COPY go.mod go.sum ./
RUN apt-get update && apt-get install --no-install-recommends -y npm=7.5.2+ds-2 && rm -rf /var/lib/apt/lists/*;
RUN npm install -g yarn@1.22.11 && npm cache clean --force;
COPY ./ /app/
RUN make clean dependencies ui permission-manager

FROM alpine:3.13
WORKDIR /root/
COPY --from=builder /app/permission-manager .
EXPOSE 4000
CMD ["./permission-manager"]
