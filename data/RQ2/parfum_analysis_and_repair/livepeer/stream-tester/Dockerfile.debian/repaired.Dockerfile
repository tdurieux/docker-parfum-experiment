FROM golang:1-stretch as builder

# RUN apk add --no-cache git

WORKDIR /root
RUN wget https://storage.googleapis.com/lp_testharness_assets/official_test_source_2s_keys_24pfs.mp4
RUN wget https://storage.googleapis.com/lp_testharness_assets/official_test_source_2s_keys_24pfs_3min.mp4
RUN wget https://storage.googleapis.com/lp_testharness_assets/bbb_sunflower_1080p_30fps_normal_t02.mp4
RUN wget https://storage.googleapis.com/lp_testharness_assets/bbb_sunflower_1080p_30fps_normal_2min.mp4

ENV GOFLAGS "-mod=readonly"
ARG version

COPY go.mod go.mod
COPY go.sum go.sum

RUN go mod download

COPY cmd cmd
COPY internal internal
COPY model model
COPY messenger messenger
COPY apis apis

RUN echo $version

RUN go build -ldflags="-X 'github.com/livepeer/stream-tester/model.Version=$version'" cmd/streamtester/streamtester.go


FROM debian:stretch-slim

WORKDIR /root
# RUN apt update && apt install -y  ca-certificates jq libgnutls30 && apt clean
RUN apt update && apt install --no-install-recommends -y ca-certificates && apt clean && rm -rf /var/lib/apt/lists/*;

COPY --from=builder /root/official_test_source_2s_keys_24pfs.mp4 official_test_source_2s_keys_24pfs.mp4
COPY --from=builder /root/official_test_source_2s_keys_24pfs_3min.mp4 official_test_source_2s_keys_24pfs_3min.mp4
COPY --from=builder /root/bbb_sunflower_1080p_30fps_normal_t02.mp4 bbb_sunflower_1080p_30fps_normal_t02.mp4
COPY --from=builder /root/bbb_sunflower_1080p_30fps_normal_2min.mp4 bbb_sunflower_1080p_30fps_normal_2min.mp4
COPY --from=builder /root/streamtester streamtester

# docker build -t livepeer/streamtester:latest .
# docker build -t livepeer/streamtester:latest --build-arg version=$(git describe --dirty) .
# docker push livepeer/streamtester:latest
# docker build -t livepeer/streamtester:test .
# docker push livepeer/streamtester:test
