FROM buildpack-deps:jessie-curl

# gpg keys listed at https://github.com/nodejs/node
RUN set -ex \
  && for key in \
    56730D5401028683275BD23C23EFEFE93C4CFFFE \
    71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
    94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
    B9AE9905FFD7803F25714661B63B535A4C206CA9 \
    C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
    DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
    FD3A5288F042B6850C66B31F09FE44734EB7990E; \
  do \
    gpg --batch --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
  done

ENV NPM_CONFIG_LOGLEVEL info
ENV NODE_URL <% if (nightly) { %><%= nightlyURL %><% } else { %><%= distURL %><% } %>
ENV NODE_VERSION <%= version %><%= hash %>
RUN buildDeps='xz-utils' \
    && set -x \
    && apt-get update \
    && apt-get install -y $buildDeps --no-install-recommends \
    && rm -rf /var/lib/apt/lists/* \
    && curl -SLO "$NODE_URL$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz" \<% if (!nightly) { %>
    && curl -SLO "$NODE_URL$NODE_VERSION/SHASUMS256.txt.asc" \<% } else { %>
    && curl -SLO "$NODE_URL$NODE_VERSION/SHASUMS256.txt" \<% } %><% if (!nightly) { %>
    && gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc \<% } %>
    && grep " node-v$NODE_VERSION-linux-x64.tar.xz\$" SHASUMS256.txt | sha256sum -c - \
    && tar -xJf "node-v$NODE_VERSION-linux-x64.tar.xz" -C /usr/local --strip-components=1 \
    && rm -f "node-v$NODE_VERSION-linux-x64.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt \
    && apt-get purge -y --auto-remove $buildDeps \
    && ln -s /usr/local/bin/node /usr/local/bin/nodejs

ENV NODE_PATH=/usr/local/lib/node_modules
RUN npm install -g lodash bluebird moment underscore q jquery && npm cache clean --force;

ENTRYPOINT bash /start.sh
