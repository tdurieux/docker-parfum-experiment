ARG GO_VERSION=1.17.9

FROM golang:${GO_VERSION}-buster as downloader

## Fetch the proof parameters.
## 1. Install the paramfetch binary first, so it can be cached over builds.
## 2. Then copy over the parameters (which could change).
## 3. Trigger the download.
## Output will be in /var/tmp/filecoin-proof-parameters.

RUN go get github.com/filecoin-project/go-paramfetch/paramfetch@master
COPY /proof-parameters.json /
RUN paramfetch 8388608 /proof-parameters.json

FROM ubuntu:18.04

RUN apt-get update && apt-get install --no-install-recommends -y ca-certificates llvm clang mesa-opencl-icd ocl-icd-opencl-dev gcc pkg-config libhwloc-dev && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y jq net-tools netcat traceroute iputils-ping wget vim curl telnet iproute2 dnsutils && rm -rf /var/lib/apt/lists/*;

COPY --from=downloader /var/tmp/filecoin-proof-parameters /var/tmp/filecoin-proof-parameters

RUN ldconfig
