FROM debian:stretch
ARG BUNDLE_DIR
RUN apt-get update && apt-get install --no-install-recommends -y ca-certificates && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;
# Use the BUNDLE_DIR build argument to copy files into the bundle
COPY . $BUNDLE_DIR