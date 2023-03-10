FROM tendermintdev/sdk-proto-gen:v0.2 as build

RUN apk add --no-cache --update \
  git \
  ca-certificates \
  nodejs

WORKDIR /workspace

COPY ./go.mod .
COPY ./go.sum .

RUN go mod download
RUN go install github.com/regen-network/cosmos-proto/protoc-gen-gocosmos
RUN npm install -g yarn && npm cache clean --force;
