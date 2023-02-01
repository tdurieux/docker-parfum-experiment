# 3scale Backend image using the Red Hat 8 Universal Base Image (UBI) for release
#
# This is based on and tracking the behavior of the more generic Dockerfile.
#
# Knobs you should know about:
#
# - RUBY_VERSION: Ruby version used.
# - BUILD_DEPS: Packages needed to build/install the project.
# - PUMA_WORKERS: Default number of Puma workers to serve the app.
#


FROM registry.access.redhat.com/ubi8/ubi-minimal

ENV HOME=/home
WORKDIR "${HOME}/app"

ARG RUBY_VERSION="2.7"

RUN echo -e "[ruby]\nname=ruby\nstream=${RUBY_VERSION}\nprofiles=\nstate=enabled\n" > /etc/dnf/modules.d/ruby.module \
 && microdnf update --nodocs \
 && microdnf install --nodocs ruby \
 && chown -R 1001:1001 "${HOME}"

ARG BUILD_DEPS="tar make file findutils git patch gcc automake autoconf libtool redhat-rpm-config openssl-devel ruby-devel"

RUN microdnf install --nodocs ${BUILD_DEPS}

RUN mkdir -p "${HOME}/.gem/bin" \
 && echo "gem: --bindir ~/.gem/bin" > "${HOME}/.gemrc"

COPY --chown=1001:1001 Gemfile.on_prem.lock "${HOME}/app/"

RUN gem uninstall --executables bundler \
 && BUNDLED_WITH=$(cat Gemfile.on_prem.lock | \
      grep -A 1 "^BUNDLED WITH$" | tail -n 1 | sed -e 's/\s//g') \
 && gem install -N bundler --version "${BUNDLED_WITH}" \
 && echo Using $(bundle --version) \
 && bundle config --local silence_root_warning 1 \
 && bundle config --local disable_shared_gems 1 \
 && bundle config --local without development:test \
 && bundle config --local gemfile Gemfile.on_prem

# Copy sources
COPY --chown=1001:1001 ./ "${HOME}/app/"

# Builds a clean source tree and deploys it with Bundler.
# Sets the right configuration and permissions.