FROM node:14.19.1-alpine

ENV WORKSPACE=registry-certs

WORKDIR /app

# Install python/pip
ENV PYTHONUNBUFFERED=1
RUN apk add --update --no-cache python3 && ln -sf python3 /usr/bin/python
RUN python3 -m ensurepip
RUN pip3 install --no-cache-dir --no-cache --upgrade pip setuptools

# Install the AWS CLI
RUN apk add --no-cache --update curl unzip git \
  && cd /tmp \
  && curl -f "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip" \
  && unzip awscli-bundle.zip \
  && ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws \
  && rm awscli-bundle.zip \
  && rm -rf awscli-bundle

# To prevent “Error: could not get uid/gid”
RUN npm config set unsafe-perm true

# Need to upgrade yarn to at least 1.6
RUN yarn global add yarn@^1.6.0 && yarn cache clean;

# This is the tar'd up collection of package.json files created by
# build-service-container.sh. Working with it and the lockfiles means we can
# cache the yarn install across builds when there are no dependency changes.
ADD package-json.tar /app/
ADD yarn.lock lerna.json .yarnrc /app/

# We don’t run the scripts because they will try to build our custom packages,
# which will fail because we don’t have the source code at this point.
#
# TODO(finh): Scope this down to $WORKSPACE when yarn has that capability.
RUN yarn install --frozen-lockfile --ignore-scripts && yarn cache clean;

ADD . /app/

RUN npx lerna run --stream --include-filtered-dependencies --scope services-js.$WORKSPACE prepare
RUN npx lerna run --stream --include-filtered-dependencies --scope services-js.$WORKSPACE prepare-deploy


EXPOSE 3000

ENV NODE_ENV production
ENV USE_SSL 1

WORKDIR /app/services-js/$WORKSPACE

ENTRYPOINT ["/app/scripts/service-entrypoint.sh"]
CMD ["yarn", "start"]
