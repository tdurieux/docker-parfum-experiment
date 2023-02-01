FROM debian:stretch

RUN apt-get -qq update \
  && apt-get install --no-install-recommends -y curl gnupg2 apt-transport-https \
  && curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && curl -f -sSL https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
  && curl -f -sL https://deb.nodesource.com/setup_12.x | bash - \
  && DEBIAN_FRONTEND=noninteractive apt-get -qq install -y --no-install-recommends \
  git ca-certificates nodejs yarn  \
  hicolor-icon-theme g++ google-chrome-stable \
  && update-alternatives --install /usr/bin/node node /usr/bin/nodejs 12 \
  && yarn config set cache-folder /var/cache/yarn \
  && rm -rf /var/lib/apt/lists/* && yarn cache clean;

ENV DAPPER_RUN_ARGS --privileged -v npm-cache:/var/cache/npm
ENV DAPPER_ENV REPO TAG DRONE_TAG IMAGE_NAME BUILD_LATEST
ENV DAPPER_SOURCE /tmp/ui
ENV DAPPER_OUTPUT ./bin ./dist
ENV DAPPER_DOCKER_SOCKET true
WORKDIR ${DAPPER_SOURCE}

RUN mkdir dist

ENTRYPOINT ["./scripts/entry.sh"]
CMD ["ci"]
