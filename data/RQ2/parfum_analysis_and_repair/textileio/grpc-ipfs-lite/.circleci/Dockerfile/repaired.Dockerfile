FROM golang:1.12.5

  # replace shell with bash so we can source files
 RUN rm /bin/sh && ln -s /bin/bash /bin/sh

  # install dependencies
 RUN apt-get update \
   && apt-get install --no-install-recommends -y curl \
   && apt-get install --no-install-recommends -y mingw-w64 \
   && apt-get install --no-install-recommends -y zip \
   && curl -f -sL https://deb.nodesource.com/setup_10.x -o nodesource_setup.sh \
   && bash nodesource_setup.sh \
   && apt-get install -y --no-install-recommends nodejs \
   && apt-get -y autoclean && rm -rf /var/lib/apt/lists/*;

  # add global node modules to path
 ENV PATH="/usr/lib/node_modules/yarn/bin:${PATH}"

  # install yarn
 RUN npm install -g yarn && npm cache clean --force;