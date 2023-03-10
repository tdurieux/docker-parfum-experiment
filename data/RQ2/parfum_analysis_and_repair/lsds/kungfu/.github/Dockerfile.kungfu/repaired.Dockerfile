# docker build --rm -t kungfu-ci-base:snapshot -f .github/Dockerfile.base .
FROM github-ci-base:latest

ADD ./scripts/download-mnist.sh /
ENV DATA_DIR /root/var/data
RUN /download-mnist.sh

WORKDIR /src/kungfu
ADD . .

RUN pip3 install --no-cache-dir --no-index -U .

ENV GOBIN /root/go/bin
RUN go install -v ./...
ENV PATH ${GOBIN}:${PATH}
ENV KUNGFU_CONFIG_ENABLE_STALL_DETECTION=true
