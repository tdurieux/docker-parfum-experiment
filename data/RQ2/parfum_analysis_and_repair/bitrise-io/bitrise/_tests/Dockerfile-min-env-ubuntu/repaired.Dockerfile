# This is the base Ubuntu environment sufficient for running the Bitrise CLI
FROM ubuntu

RUN apt-get update -qq

# Required for `bitrise setup`
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install ca-certificates git && rm -rf /var/lib/apt/lists/*;
# Required for `deps`
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install sudo && rm -rf /var/lib/apt/lists/*;
