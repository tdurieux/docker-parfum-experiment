ARG     TEST_BASE
FROM    ${TEST_BASE}
ENV     GO111MODULE=off
WORKDIR /go/src/github.com/docker/compose-on-kubernetes
RUN apt update && apt install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*
RUN go get -u github.com/wadey/gocovmerge
COPY . .
RUN make test
