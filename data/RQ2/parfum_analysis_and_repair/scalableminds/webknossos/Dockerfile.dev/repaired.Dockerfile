FROM scalableminds/sbt:master__113
ARG VERSION_NODE="12.x"

ENV DEBIAN_FRONTEND noninteractive

# Fixes "The method driver /usr/lib/apt/methods/https could not be found."
# See https://unix.stackexchange.com/a/478009
RUN apt-get update && apt-get install -y --no-install-recommends apt-transport-https && rm -rf /var/lib/apt/lists/*;

# Fixes "The repository 'https://deb.nodesource.com/node_12.x stretch Release' does no longer have a Release file."
# https://github.com/nodesource/distributions/issues/1266#issuecomment-931467582
# https://github.com/nodesource/distributions/issues/1266#issuecomment-931481002
# https://github.com/nodesource/distributions/issues/1266#issuecomment-933102213
RUN apt-get install -y --no-install-recommends openssl ca-certificates libgnutls30 && rm /usr/share/ca-certificates/mozilla/DST_Root_CA_X3.crt && update-ca-certificates && rm -rf /var/lib/apt/lists/*;

# add node package source
RUN curl -f -sL "https://deb.nodesource.com/setup_${VERSION_NODE}" | bash -

# add yarn package source
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list \
  && curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -

# Install sbt, node & build-essentials
RUN apt-get update \
  && apt-get install --no-install-recommends -y \
      build-essential \
      findutils \
      nodejs \
      postgresql-client \
      yarn \
  # The following packages are necessary to run headless-gl
  && apt-get install --no-install-recommends -y \
      mesa-utils xvfb libgl1-mesa-dri libglapi-mesa libosmesa6 pkg-config x11proto-xext-dev xserver-xorg-dev libxext-dev libxi-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
