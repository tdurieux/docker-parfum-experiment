FROM golang:1.14

WORKDIR /app
RUN apt-get update && apt-get install -y unzip --no-install-recommends --assume-yes && rm -rf /var/lib/apt/lists/*;
RUN PROTOC_ZIP=protoc-3.17.3-linux-x86_64.zip && \
 curl -f -OL https://github.com/protocolbuffers/protobuf/releases/download/v3.17.3/$PROTOC_ZIP && \
unzip -o $PROTOC_ZIP -d /usr/local bin/protoc && \
unzip -o $PROTOC_ZIP -d /usr/local 'include/*' && \
rm -f $PROTOC_ZIP
COPY . .
RUN make install-protoc && make generate-proto && make update-deps && make compile

FROM debian:buster-slim
WORKDIR /app
COPY --from=0 /app/out/raccoon ./raccoon
COPY . .
CMD ["./raccoon"]
