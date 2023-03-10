# Built from https://github.com/qwandor/cross/blob/context/docker/Dockerfile.context
FROM ghcr.io/qwandor/cross-context:0.2.1 as context

FROM debian:buster

COPY --from=context common.sh lib.sh /
RUN /common.sh

COPY --from=context cmake.sh /
RUN /cmake.sh

COPY --from=context xargo.sh /
RUN /xargo.sh

RUN apt-get update && \
	apt-get install --no-install-recommends -y libdbus-1-dev && rm -rf /var/lib/apt/lists/*;
