FROM multiarch/ubuntu-debootstrap:i386-bionic

ARG PGPATH

ENV PATH "${PGPATH}:${PATH}"
ENV TEST_USER ruby-pg

WORKDIR /build
COPY . .

RUN uname -a
RUN apt-get update -qq && \
  # "rake compile" gets error with below options.
  # apt-get install -yq --no-install-suggests --no-install-recommends \
  apt-get install -yq \
  -o Dpkg::Options::='--force-confnew' \
  libgmp-dev \
  libpq-dev \
  libssl-dev \
  postgresql \
  ruby \
  ruby-dev \
  pkg-config \
  software-properties-common \
  sudo \
  wget
RUN add-apt-repository -y universe && \
  apt-get update -qq && \
  apt-get install -yq ruby-bundler
RUN ruby --version
RUN pg_ctl --version
# Create test user and the environment
RUN useradd "${TEST_USER}"
RUN chown -R "${TEST_USER}:${TEST_USER}" /build
# Enable sudo without password for convenience.
RUN echo "${TEST_USER} ALL = NOPASSWD: ALL" >> /etc/sudoers
USER "${TEST_USER}"

CMD bundle install --path vendor/bundle && \
    (bundle exec rake compile || (head -20 mkmf.log; false)) && \
    (bundle exec rake test || (head -20 ./tmp_test_specs/setup.log; false))
