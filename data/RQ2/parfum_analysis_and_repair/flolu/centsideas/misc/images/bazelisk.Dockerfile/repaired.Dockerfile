FROM ubuntu:18.04

RUN apt-get update
RUN apt-get -y --no-install-recommends install curl gnupg unzip python python3 git build-essential && rm -rf /var/lib/apt/lists/*;

# nodejs
RUN apt-get -y --no-install-recommends install nodejs && rm -rf /var/lib/apt/lists/*;

# yarn
RUN curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update && apt-get -y --no-install-recommends install yarn && rm -rf /var/lib/apt/lists/*;

# bazelisk
RUN yarn global add @bazel/bazelisk --prefix /usr/local && bazelisk version

WORKDIR /app

ENTRYPOINT [ "bazelisk" ]