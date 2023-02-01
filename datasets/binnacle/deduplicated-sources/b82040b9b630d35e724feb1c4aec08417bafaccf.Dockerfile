FROM ubuntu:xenial
MAINTAINER Grow SDK Authors <hello@grow.io>

RUN echo "Grow: Master"

# Set environment variables.
ENV TERM=xterm

RUN apt-get update \
  && apt-get install -y --no-install-recommends curl ca-certificates \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Node, Yarn, GCloud sources.
RUN curl -sL https://deb.nodesource.com/setup_9.x | bash - \
  && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
  && echo "deb http://packages.cloud.google.com/apt cloud-sdk-$(lsb_release -c -s) main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

# Install Grow dependencies.
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    python python-pip python-setuptools nodejs build-essential python-all-dev zip \
    libc6 libyaml-dev libffi-dev libxml2-dev libxslt-dev libssl-dev \
    git curl ssh google-cloud-sdk ruby ruby-dev yarn \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Update npm and install packages.
RUN npm install -g npm@latest \
  && yarn global add bower \
  && yarn global add gulp \
  && yarn cache clean

# Install Grow.
RUN pip install --no-cache-dir --upgrade wheel \
  && pip install --no-cache-dir git+git://github.com/grow/grow.git@master

# Install ruby bundle.
RUN gem install bundler

# Confirm versions that are installed.
RUN echo "Grow: `grow --version`" \
  && echo "Node: `node -v`" \
  && echo "NPM: `npm -v`" \
  && echo "Yarn: `yarn --version`" \
  && echo "Gulp: `gulp -v`" \
  && echo "GCloud: `gcloud -v`" \
  && echo "Ruby: `ruby -v`"
