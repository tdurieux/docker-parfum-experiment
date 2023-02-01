FROM golang:1.18.1@sha256:ee752bc53c628ff789bacefb714cff721701042ffa9eb736f7b2ed4e9f2bdab6

RUN apt-get update && apt-get install --no-install-recommends -y make git apt-transport-https ca-certificates curl software-properties-common build-essential zip xmlsec1 jq && rm -rf /var/lib/apt/lists/*;
