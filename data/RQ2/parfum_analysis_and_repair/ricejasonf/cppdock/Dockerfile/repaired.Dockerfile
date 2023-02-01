FROM ubuntu:eoan

RUN apt-get update \
  && apt-get -yq --no-install-recommends install \
      python cmake git autoconf bash-completion vim wget \
  && echo '. /usr/share/bash-completion/bash_completion && set -o vi' >> /root/.bashrc \
  && echo 'set hlsearch' >> /root/.vimrc && rm -rf /var/lib/apt/lists/*;

COPY cppdock /usr/local/bin/
COPY cppdock /opt/install/bin/
COPY recipes/ /root/.cppdock_recipes
