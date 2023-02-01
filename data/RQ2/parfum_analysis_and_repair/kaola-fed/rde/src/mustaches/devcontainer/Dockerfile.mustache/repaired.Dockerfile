FROM {{{from}}}

# Configure apt
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
  && apt-get -y install --no-install-recommends apt-utils 2>&1 && rm -rf /var/lib/apt/lists/*;

# Verify git and process tools are installed
RUN apt-get install --no-install-recommends -y git procps && rm -rf /var/lib/apt/lists/*;

# Remove outdated yarn from /opt and install via package
# so it can be easily updated via apt-get upgrade yarn
RUN rm -rf /opt/yarn-* \
  && rm -f /usr/local/bin/yarn \
  && rm -f /usr/local/bin/yarnpkg \
  && apt-get install --no-install-recommends -y curl apt-transport-https lsb-release \
  && curl -f -sS https://dl.yarnpkg.com/$(lsb_release -is | tr '[:upper:]' '[:lower:]')/pubkey.gpg | apt-key add - 2>/dev/null \
  && echo "deb https://dl.yarnpkg.com/$(lsb_release -is | tr '[:upper:]' '[:lower:]')/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update \
  && apt-get -y install --no-install-recommends yarn && rm -rf /var/lib/apt/lists/*;

RUN yarn global add rde

# Clean up
RUN apt-get autoremove -y \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/*
ENV DEBIAN_FRONTEND=dialog

# Set the default shell to bash rather than sh
ENV SHELL /bin/bash
ENV DOCKER_ENV true
