#
# Run release archive builder within Docker container.
#

FROM golang:1.16

RUN apt-get update && apt-get --yes --no-install-recommends install zip && rm -rf /var/lib/apt/lists/*;

COPY . /src
WORKDIR /src

ARG NAME
ARG VERSION
RUN NAME=${NAME} VERSION=${VERSION} ./devtools/release_build.sh
