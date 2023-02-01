FROM debian:buster
ARG DEBIAN_FRONTEND=noninteractive

SHELL ["/bin/bash", "-c"]

RUN apt-get update && apt-get --assume-yes -y --no-install-recommends install curl openssh-client && rm -rf /var/lib/apt/lists/*;
# cypress dependencies for running electron
RUN apt-get install -y --no-install-recommends --assume-yes libgtk2.0-0 libgtk-3-0 libgbm-dev libnotify-dev libgconf-2-4 libnss3 libxss1 libasound2 libxtst6 xauth xvfb && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sL https://deb.nodesource.com/setup_14.x | bash - && \
 curl -f -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
&& echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

COPY sources.list /etc/apt/sources.list.d/15_ucs-online-version.list
RUN \
  set -euxo pipefail && \
  echo 'nameserver 192.168.0.97' > /etc/resolv.conf && \
  printf -v URL '%s' \
    'https://updates.software-univention.de/' \
    'univention-archive-key-ucs-5x.gpg' && \
  curl -fsSL "${URL}" | apt-key add - && \
  apt-get update && \
  apt-get --assume-yes -y --verbose-versions --no-install-recommends install \
    univention-l10n-dev devscripts debhelper nodejs yarn build-essential && \
  rm -rf /var/lib/apt/lists/*

WORKDIR /tmpinstall/
RUN yarn add --dev cypress && yarn cache clean;

WORKDIR /debbuilder/
ENV NODE_ENV=sandbox
