FROM ubuntu:18.04 AS dev

COPY scripts/docker-install-build.bash /tmp/
RUN /tmp/docker-install-build.bash

ENV PATH="/usr/local/go/bin:$PATH"

COPY scripts/docker-install-languages.bash /tmp/
RUN /tmp/docker-install-languages.bash

COPY go.mod go.sum scripts/docker-prefetch.bash /tmp/
RUN /tmp/docker-prefetch.bash

COPY scripts/docker-setup-dev.bash /tmp/
RUN /tmp/docker-setup-dev.bash

ENV PATH="/upm/cmd/upm:$PATH"
WORKDIR /upm