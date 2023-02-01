FROM quay.io/bitriseio/bitrise-base

RUN apt-get update && apt-get -y --no-install-recommends install \
    ruby-dev \
    nodejs \
    liblzma-dev && rm -rf /var/lib/apt/lists/*;

RUN gem install -f bundler:2.1.4

COPY . /bitrise/src
WORKDIR /bitrise/src

RUN bundle install
RUN npm ci
