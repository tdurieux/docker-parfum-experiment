# BASED ON
# https://blog.codeminer42.com/zero-to-up-and-running-a-rails-project-only-using-docker-20467e15f1be/

# Specify the Docker image to use as a base:
FROM ruby:RUBY_VERSION

ENV DEBIAN_FRONTEND=noninteractive \
    NODE_VERSION=14.16.0

RUN sed -i '/deb-src/d' /etc/apt/sources.list && \
    apt-get update && \
    apt-get install --no-install-recommends -y build-essential tree graphviz && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sSL "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz" | tar xfJ - -C /usr/local --strip-components=1 && \
    npm install npm -g && npm cache clean --force;

# Install Yarn (same procedure as that used in the Node Docker image builds)
ENV YARN_VERSION 1.22.5
RUN set -ex \
  && for key in \
    6A010C5166006599AA17F08146C2130DFD2497F5; \
  do \
    gpg --batch --keyserver hkp://p80.ha.pool.sks-keyservers.net:80 --recv-keys "$key" || \
    gpg --batch --keyserver hkp://ipv4.ha.pool.sks-keyservers.net --recv-keys "$key" || \
    gpg --batch --keyserver hkp://pgp.mit.edu:80 --recv-keys "$key"; \
  done \
  && curl -fsSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz" \
  && curl -fsSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz.asc" \
  && gpg --batch --verify yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz \
  && mkdir -p /opt \
  && tar -xzf yarn-v$YARN_VERSION.tar.gz -C /opt/ \
  && ln -s /opt/yarn-v$YARN_VERSION/bin/yarn /usr/local/bin/yarn \
  && ln -s /opt/yarn-v$YARN_VERSION/bin/yarnpkg /usr/local/bin/yarnpkg \
  && rm yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz \
  # smoke test
  && yarn --version

RUN useradd -m -s /bin/bash -u 1000 docker_user
USER docker_user

WORKDIR /home/docker_user/pie
