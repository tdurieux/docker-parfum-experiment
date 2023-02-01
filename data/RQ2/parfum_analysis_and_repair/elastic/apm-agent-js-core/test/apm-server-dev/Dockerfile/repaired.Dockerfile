FROM golang:1.10.3

ARG APM_SERVER_BRANCH
ARG APM_SERVER_REPO

RUN apt-get update \
    && apt-get install -y wget git --no-install-recommends \
    && apt-get install --no-install-recommends -y virtualenv && rm -rf /var/lib/apt/lists/*;

RUN git clone -b $APM_SERVER_BRANCH --single-branch https://github.com/$APM_SERVER_REPO.git --depth 1 ${GOPATH}/src/github.com/elastic/apm-server

WORKDIR ${GOPATH}/src/github.com/elastic/apm-server

RUN make
RUN make update