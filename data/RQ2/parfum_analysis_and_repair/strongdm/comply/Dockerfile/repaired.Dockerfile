FROM strongdm/pandoc:edge

# based on implementation by James Gregory <james@jagregory.com>
MAINTAINER Comply <comply@strongdm.com>

RUN apt-get update -y \
  && apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

ARG COMPLY_VERSION
ENV COMPLY_VERSION ${COMPLY_VERSION:-1.6.0}

EXPOSE 4000/tcp

# install comply binary
RUN curl -f -J -L -o /tmp/comply.tgz https://github.com/strongdm/comply/releases/download/v${COMPLY_VERSION}/comply-v${COMPLY_VERSION}-linux-amd64.tgz \
  && tar -xzf /tmp/comply.tgz \
  && mv ./comply-v${COMPLY_VERSION}-linux-amd64 /usr/local/bin/comply && rm /tmp/comply.tgz

WORKDIR /source

ENTRYPOINT ["/bin/bash"]