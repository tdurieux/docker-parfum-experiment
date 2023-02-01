FROM debian:stretch-slim
ARG unum_version=2019.2.0

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        build-essential \
        gawk \
        gettext \
        git \
        libcurl4-openssl-dev \
        libjansson-dev \
        libnl-3-dev \
        libnl-genl-3-dev \
        libssl-dev \
        vim && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/local/src/unum
COPY . .

RUN make MODEL=linux_generic AGENT_VERSION=${unum_version}
