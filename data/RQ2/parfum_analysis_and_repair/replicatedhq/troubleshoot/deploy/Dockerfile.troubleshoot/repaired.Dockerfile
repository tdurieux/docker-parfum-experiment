FROM debian:buster
WORKDIR /

RUN apt-get -qq update \
 && apt-get -qq --no-install-recommends -y install \
    ca-certificates kmod && rm -rf /var/lib/apt/lists/*;

COPY support-bundle /troubleshoot/support-bundle
COPY preflight /troubleshoot/preflight
COPY collect /troubleshoot/collect

ENV PATH="/troubleshoot:${PATH}"

