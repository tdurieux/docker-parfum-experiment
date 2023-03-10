FROM livepeerci/build AS builder

RUN apt install --no-install-recommends -y wget tar && rm -rf /var/lib/apt/lists/*;

WORKDIR /root
RUN wget -qO- https://storage.googleapis.com/lp_testharness_assets/official_test_source_2s_keys_24pfs_30s_hls.tar.gz | tar xvz -C .

COPY go.mod go.mod
COPY go.sum go.sum

RUN go mod download

ARG version
RUN echo $version

COPY . .

RUN go build -ldflags="-X 'github.com/livepeer/stream-tester/model.Version=$version' -X 'github.com/livepeer/stream-tester/model.IProduction=true'" -tags mainnet cmd/orch-tester/orch_tester.go cmd/orch-tester/broadcaster_metrics.go

FROM debian:stretch-slim

RUN apt update \
  && apt install --no-install-recommends -y ca-certificates \
  && apt clean && apt autoclean && rm -rf /var/lib/apt/lists/*;
RUN update-ca-certificates

WORKDIR /root

COPY --from=builder /root/official_test_source_2s_keys_24pfs_30s_hls official_test_source_2s_keys_24pfs_30s_hls
COPY --from=builder /root/orch_tester orch_tester

ENTRYPOINT ["/root/orch_tester"]
