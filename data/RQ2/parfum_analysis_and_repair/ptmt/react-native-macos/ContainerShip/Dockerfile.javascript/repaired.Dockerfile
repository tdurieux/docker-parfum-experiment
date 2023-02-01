FROM library/node:6.9.2

ENV YARN_VERSION=0.27.5

# install dependencies
RUN apt-get update && apt-get install --no-install-recommends ocaml libelf-dev -y && rm -rf /var/lib/apt/lists/*;
RUN npm install yarn@$YARN_VERSION -g && npm cache clean --force;

# add code
RUN mkdir /app
ADD . /app

WORKDIR /app
RUN yarn install --ignore-engines && yarn cache clean;

WORKDIR website
RUN yarn install --ignore-engines --ignore-platform && yarn cache clean;

WORKDIR /app
