# Docker image with plain nodejs and npm.

FROM {{ "ci-bullseye" | image_tag }}

USER root

ENV NODE_VERSION=v14.17.5-linux-x64

RUN {{ "curl" | apt_install }}

COPY SHASUMS256.txt /tmp/nodeinstall/SHASUMS256.txt
RUN cd /tmp/nodeinstall \
    && curl -f -Lo node-${NODE_VERSION}.tar.gz https://nodejs.org/dist/v14.17.5/node-${NODE_VERSION}.tar.gz \
    && grep node-${NODE_VERSION}.tar.gz SHASUMS256.txt | sha256sum -c - \
    && tar -xzf node-${NODE_VERSION}.tar.gz \
    && mv node-${NODE_VERSION}/bin/node /usr/bin/node \
    && ln -s /usr/bin/node /usr/bin/nodejs \
    && mv node-${NODE_VERSION}/share/ /usr/share/nodejs \
    && mv node-${NODE_VERSION}/include/node /usr/include/node \
    # TODO: Are you creating the node16 image?
    #       Remember to de-comment the below and remove the manually pinned npm.
    #       Node 16 comes with npm 7. We'll follow upstream from Node 16 on.
    # && mv node-${NODE_VERSION}/lib/node_modules /usr/lib/node_modules \
    # && ln -s /usr/lib/node_modules/npm/bin/npm-cli.js /usr/bin/npm \
    # && ln -s /usr/lib/node_modules/npm/bin/npx-cli.js /usr/bin/npx \
    && rm -rf /tmp/nodeinstall && rm node-${NODE_VERSION}.tar.gz

# Pin our Node 14 image to npm 7.x. Official Node.js 14 tarballs come with npm 6,
# but, we upgraded npm and we're sticking to it.
RUN git clone --depth 1 https://gerrit.wikimedia.org/r/integration/npm.git -b npm-7.21.0 /srv/npm \
    && rm -rf /srv/npm/.git \
    && ln -s /srv/npm/bin/npm-cli.js /usr/bin/npm \
    && ln -s /srv/npm/bin/npx-cli.js /usr/bin/npx

USER nobody

ENTRYPOINT ["npm"]
CMD ["--help"]
