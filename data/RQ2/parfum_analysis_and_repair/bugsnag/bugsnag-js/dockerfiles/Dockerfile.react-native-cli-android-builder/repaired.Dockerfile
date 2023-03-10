FROM 855461928731.dkr.ecr.us-west-1.amazonaws.com/js:android-builder-base

RUN apt-get update && apt-get install --no-install-recommends -y nodejs rsync expect \

                                         ruby-full apt-utils docker-compose wget unzip bash bundler \

                                         zlib1g libpng-dev zlibc zlib1g zlib1g-dev curl \

                                         libcurl4 libcurl4-openssl-dev && rm -rf /var/lib/apt/lists/*;

RUN npm i -g run-func && npm cache clean --force;

WORKDIR /app

# Install MazeRunner as a Gem
COPY test/react-native-cli/Gemfile Gemfile
RUN bundle install

# npm auth
RUN rm -f ~/.npmrc
ARG REGISTRY_URL
ARG REG_BASIC_CREDENTIAL
ARG REG_NPM_EMAIL
RUN echo "registry=$REGISTRY_URL" >> ~/.npmrc
RUN echo "_auth=$REG_BASIC_CREDENTIAL" >> ~/.npmrc
RUN echo "email=$REG_NPM_EMAIL" >> ~/.npmrc
RUN echo "always-auth=true" >> ~/.npmrc

# Now copy in all the files needed to build
COPY .git .git
COPY lerna.json .
COPY scripts/common.js scripts/react-native-cli-helper.js scripts/

RUN bundle exec maze-runner --version

ENTRYPOINT ["bundle", "exec", "maze-runner"]
