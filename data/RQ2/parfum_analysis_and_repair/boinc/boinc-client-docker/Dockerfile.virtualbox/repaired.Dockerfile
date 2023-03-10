FROM boinc/client:base-ubuntu

LABEL maintainer="BOINC" \
      description="VirtualBox-savvy BOINC client."

# Install
RUN apt-get update && apt-get install -y --no-install-recommends \
# Install VirtualBox
    virtualbox && \
    echo virtualbox-ext-pack virtualbox-ext-pack/license select true | debconf-set-selections && \
    apt-get install -y --no-install-recommends virtualbox-ext-pack && \
# Cleaning up
    rm -rf /var/lib/apt/lists/*