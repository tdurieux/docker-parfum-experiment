FROM i386/ubuntu:bionic

ARG PGPATH

ENV PATH "${PGPATH}:${PATH}"
ENV TEST_USER ruby-pg
# To prevent installed tzdata deb package to show interactive dialog.
ENV DEBIAN_FRONTEND noninteractive

WORKDIR /build
COPY . .

RUN uname -a
RUN apt-get update -qq && \
  # "rake compile" gets error with below options.
  # apt-get install -yq --no-install-suggests --no-install-recommends \
  apt-get install --no-install-recommends -yq \
  -o Dpkg::Options::='--force-confnew' \
  libgmp-dev \
  libpq-dev \
  libssl-dev \
  postgresql \
  git \
  ruby \
  ruby-dev \
  pkg-config \
  software-properties-common \
  sudo \
  wget && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository -y universe && \
  apt-get update -qq && \
  apt-get install --no-install-recommends -yq ruby-bundler && rm -rf /var/lib/apt/lists/*;
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
