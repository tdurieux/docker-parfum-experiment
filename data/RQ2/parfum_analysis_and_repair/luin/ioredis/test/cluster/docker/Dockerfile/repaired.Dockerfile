FROM grokzen/redis-cluster

RUN apt-get --allow-releaseinfo-change update

RUN apt-get update -y && apt-get install --no-install-recommends -y redis-server && apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN touch /etc/apt/apt.conf.d/99verify-peer.conf \
  && echo >>/etc/apt/apt.conf.d/99verify-peer.conf "Acquire { https::Verify-Peer false }"
RUN echo insecure >> $HOME/.curlrc

RUN curl --insecure -fsSL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN apt-get clean
RUN mkdir /code
WORKDIR /code
ADD package.json package-lock.json ./
# Install npm dependencies without converting the lockfile version in npm 7,
# and remove temporary files to save space when developing locally.
RUN npm install --no-save && npm cache clean --force

