FROM heroku/heroku:18

ENV DEBIAN_FRONTEND=noninteractive
ARG DOWNLOAD_URL=https://developer.salesforce.com/media/salesforce-cli/sfdx/channels/stable-rc/sfdx-linux-x64.tar.xz
RUN apt-get update && apt-get install -y --no-install-recommends --assume-yes \
  openjdk-11-jdk-headless && rm -rf /var/lib/apt/lists/*; # install cli from linux tarball with bundled node
RUN curl -f -s $DOWNLOAD_URL --output sfdx-linux-x64.tar.xz \
  && mkdir -p /usr/local/sfdx \
  && tar xJf sfdx-linux-x64.tar.xz -C /usr/local/sfdx --strip-components 1 \
  && rm sfdx-linux-x64.tar.xz




RUN apt-get autoremove --assume-yes \
  && apt-get clean --assume-yes \
  && rm -rf /var/lib/apt/lists/*

ENV PATH="/usr/local/sfdx/bin:$PATH"
ENV SFDX_CONTAINER_MODE true
ENV DEBIAN_FRONTEND=dialog
ENV SHELL /bin/bash
