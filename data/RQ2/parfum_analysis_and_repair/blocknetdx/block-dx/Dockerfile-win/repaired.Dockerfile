FROM electronuserland/builder:wine

# Create app directory
RUN mkdir -p /opt/block-dx/dist-native

WORKDIR /opt/block-dx/
VOLUME /opt/block-dx/dist-native

# Install app dependencies
COPY package.json /opt/block-dx/
RUN npm install --no-audit && npm cache clean --force;

# Bundle app source
COPY . /opt/block-dx/

ARG GIT_BRANCH=""
RUN if [ ! -z "$GIT_BRANCH" ]; then echo GIT_BRANCH=$GIT_BRANCH > /opt/block-dx/electron-builder.env; fi

ENTRYPOINT ["npm"]
CMD ["run", "build-native-win"]
