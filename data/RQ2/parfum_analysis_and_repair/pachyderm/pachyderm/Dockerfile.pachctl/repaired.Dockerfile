FROM debian:buster-slim
RUN apt update && apt install --no-install-recommends -y ca-certificates && rm -rf /var/lib/apt/lists/*;

COPY LICENSE /LICENSE
COPY licenses /licenses
COPY pachctl /usr/local/bin/pachctl
