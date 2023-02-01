#--------------------------------------------------------------------------------------------------
# This dockerfile builds a minimal ubuntu-based image for running a sanity smoketest during the
# automated release process.
#
# It requires the same files/assets as the unified smoke/unit Dockerfile
#
# Example build command:
#   docker build -f <thisfile> -t scalyr/scalyr-agent-ci-sanity:ubuntu.1 .
#--------------------------------------------------------------------------------------------------

FROM ubuntu

RUN apt-get update && apt-get install --no-install-recommends -y curl python python3 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends perl && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir requests
RUN apt-get install -y --no-install-recommends sudo && rm -rf /var/lib/apt/lists/*;

#------------------------------------------------------
# Copy and run test scripts
#------------------------------------------------------
COPY unittest smoketest /tmp/
