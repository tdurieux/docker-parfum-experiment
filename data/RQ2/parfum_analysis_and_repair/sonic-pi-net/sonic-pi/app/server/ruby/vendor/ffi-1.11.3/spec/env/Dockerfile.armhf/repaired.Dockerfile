# See .travis.yml how this docker image can be used.
FROM multiarch/ubuntu-debootstrap:armhf-bionic

RUN uname -a
RUN apt-get update -qq && \
  apt-get install --no-install-recommends -yq \
    autoconf \
    automake \
    file \
    gcc \
    git \
    libtool \
    make \
    ruby-dev && rm -rf /var/lib/apt/lists/*;
RUN ruby --version

WORKDIR /ffi
COPY . .

RUN gem install bundler --no-doc && \
    bundle install

CMD bundle install && \
    bundle exec rake compile && \
    bundle exec rake test
