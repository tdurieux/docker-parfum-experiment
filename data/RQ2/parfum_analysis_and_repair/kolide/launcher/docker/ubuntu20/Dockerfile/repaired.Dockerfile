ARG FAKE
FROM launcher${FAKE}-build as stage1

FROM ubuntu:20.04
LABEL maintainer="engineering@kolide.co"

COPY --from=stage1 /usr/local/kolide/bin/* /usr/local/kolide/bin/

# Launcher does cert verification. Ensure certs.
RUN apt-get update && apt-get install --no-install-recommends ca-certificates -y && rm -rf /var/lib/apt/lists/*;

# Set entrypoint
ENTRYPOINT ["/usr/local/kolide/bin/launcher"]
CMD []
