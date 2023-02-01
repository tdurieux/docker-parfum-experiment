FROM reactioncommerce/meteor:2.5.0-v1 as builder

ENV APP_SOURCE_DIR /usr/local/src/appsrc
ENV APP_BUNDLE_DIR /usr/local/src/build
ENV TOOL_NODE_FLAGS --max-old-space-size=4096

USER root

RUN mkdir -p "$APP_SOURCE_DIR" \
 && mkdir -p "$APP_BUNDLE_DIR" \
 && chown -R node "$APP_SOURCE_DIR" \
 && chown -R node "$APP_BUNDLE_DIR"

COPY --chown=node . $APP_SOURCE_DIR

WORKDIR $APP_SOURCE_DIR

USER node

RUN npm install --no-audit
RUN node --experimental-modules ./.reaction/scripts/build.mjs
RUN printf "\\n[-] Building Meteor application...\\n" \
 && /home/node/.meteor/meteor build --server-only --architecture os.linux.x86_64 --directory "$APP_BUNDLE_DIR"

##############################################################################
# final build stage - create the final production image
##############################################################################
FROM node:14.18.1-slim
ENV NPM_VERSION 8.5.5

LABEL maintainer="Mailchimp Open Commerce <hello-open-commerce@mailchimp.com>"

# grab the dependencies and built app from the previous temporary builder image
COPY --chown=node --from=builder /usr/local/src/build/bundle /usr/local/src/app

# copy the waitForMongo script, too
COPY --chown=node --from=builder /usr/local/src/appsrc/.reaction/waitForMongo.js /usr/local/src/app/programs/server/waitForMongo.js

RUN npm i -g npm@${NPM_VERSION}

WORKDIR /usr/local/src/app/programs/server/

RUN npm install --omit-dev --no-audit

# Also install mongodb pkg needed by the waitForMongo script
RUN npm install -E --no-save mongodb@3.5.7

WORKDIR /usr/local/src/app

ENV PATH $PATH:/usr/local/src/app/programs/server/node_modules/.bin

CMD ["sh", "-c", "cd programs/server && node waitForMongo.js && cd ../.. && node main.js"]
