FROM blazemeter/taurus:1.15.1

RUN curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update && \
  apt-get install -y --no-install-recommends yarn && \
  yarn install && yarn cache clean; && rm -rf /var/lib/apt/lists/*;
