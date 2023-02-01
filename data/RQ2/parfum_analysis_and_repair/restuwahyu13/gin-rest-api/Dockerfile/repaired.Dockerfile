# ======================
#  GO FIRST STAGE
# ======================

FROM golang:latest as builder
USER ${USER}
WORKDIR /usr/src/app
COPY go.mod \
  go.sum ./
RUN go mod download
COPY . ./
ENV GO111MODULE="on" \
  GOARCH="amd64" \
  GOOS="linux" \
  CGO_ENABLED="0"
RUN apt-get clean \
  && apt-get remove

# ======================
#  GO FINAL STAGE
# ======================

FROM builder
WORKDIR /usr/src/app
RUN apt-get update \
  && apt-get install --no-install-recommends -y \
  make \
  vim \
  build-essential && rm -rf /var/lib/apt/lists/*;
COPY --from=builder . ./usr/src/app
RUN make goprod
EXPOSE 4000
CMD ["./main"]