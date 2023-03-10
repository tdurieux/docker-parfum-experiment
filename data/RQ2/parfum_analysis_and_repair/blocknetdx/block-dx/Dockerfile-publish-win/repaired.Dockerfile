FROM electronuserland/builder:wine

ARG GIT_BRANCH=""

# Pull app source from git
RUN mkdir -p /opt \
  && cd /opt \
  && git clone --depth 1 --branch $GIT_BRANCH https://github.com/blocknetdx/block-dx.git \
  && cd /opt/block-dx \
  && mkdir -p dist-native \
  && echo GIT_BRANCH=$GIT_BRANCH > /opt/block-dx/electron-builder.env

# Install app dependencies
RUN cd /opt/block-dx \
  && npm install --no-audit && npm cache clean --force;

WORKDIR /opt/block-dx/
VOLUME /opt/block-dx/dist-native

ENTRYPOINT ["npm"]
CMD ["run", "publish-native-win"]
