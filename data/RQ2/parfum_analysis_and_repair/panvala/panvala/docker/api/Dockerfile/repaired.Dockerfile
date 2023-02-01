FROM ubuntu:18.04
# mhart/alpine-node

# application will be installed here
WORKDIR /srv

# Install Postgres, Node


RUN apt-get update && apt-get install --no-install-recommends -y curl gnupg && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# Set up for node 10 install
RUN curl -f -sL https://deb.nodesource.com/setup_10.x | bash -

# RUN apt-get update && apt remove -y cmdtest && apt-get install -y \
RUN apt-get update && apt-get install --no-install-recommends -y \
    postgresql-client \
    nodejs \
    yarn && rm -rf /var/lib/apt/lists/*;

# copy shared libs and run install
COPY ./packages/panvala-utils/ ../packages/panvala-utils
RUN cd ../packages/panvala-utils && yarn && yarn cache clean;

# Install node dependencies
COPY ./api/package.json .
COPY ./api/yarn.lock .
RUN ls
RUN yarn && yarn cache clean;

# copy our code to the server
COPY ./api .

# run the build
RUN yarn build && yarn cache clean;

EXPOSE 5000

CMD ["yarn", "start"]
