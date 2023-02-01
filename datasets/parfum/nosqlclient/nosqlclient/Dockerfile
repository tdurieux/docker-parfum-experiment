FROM debian:jessie

RUN groupadd -r node -g 1000 && useradd -m -g node -u 1000 node

ENV NODE_VERSION 12.16.1
ENV GOSU_VERSION 1.10

# default values for Meteor environment variables
ENV ROOT_URL http://localhost

ENV PORT 3000
ENV INSTALL_MONGO true
ENV MONGOCLIENT_DEFAULT_CONNECTION_URL ''
ENV MONGOCLIENT_CONNECTIONS_FILE_PATH /opt/meteor/dist/predefined_connections.json

# build directories
ENV APP_SOURCE_DIR /opt/meteor/src
ENV APP_BUNDLE_DIR /opt/meteor/dist
ENV BUILD_SCRIPTS_DIR /opt/build_scripts

# add entrypoint and build scripts
COPY .docker $BUILD_SCRIPTS_DIR
RUN chmod -R 770 $BUILD_SCRIPTS_DIR

# install base dependencies, build app, cleanup
RUN cd $BUILD_SCRIPTS_DIR && \
		bash $BUILD_SCRIPTS_DIR/install-deps.sh && \
		bash $BUILD_SCRIPTS_DIR/install-node.sh && \
		bash $BUILD_SCRIPTS_DIR/install-mongo.sh && \
		bash $BUILD_SCRIPTS_DIR/post-install-cleanup.sh

# copy the app to the container
COPY . $APP_SOURCE_DIR

# install Meteor, build app, clean up
RUN cd $APP_SOURCE_DIR && \
            bash $BUILD_SCRIPTS_DIR/install-meteor.sh && \
            bash $BUILD_SCRIPTS_DIR/build-meteor.sh && \
            bash $BUILD_SCRIPTS_DIR/post-build-cleanup.sh

# fix tunnel-ssh npm missing module
RUN cp -R $APP_BUNDLE_DIR/bundle/programs/server/npm/node_modules/tunnel-ssh $APP_BUNDLE_DIR/bundle/programs/server/npm/node_modules/meteor/modules-runtime/node_modules/

EXPOSE 3000
USER node
WORKDIR $APP_BUNDLE_DIR/bundle

# start the app
ENTRYPOINT ["./entrypoint.sh"]
CMD ["node", "main.js"]
