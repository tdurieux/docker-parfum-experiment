# 3scale Backend image using the Red Hat 8 Universal Base Image (UBI) as base
#
# This image is meant for flexibility building different configurations.
#
# Knobs you should know about:
#
# - RUBY_VERSION: Ruby version used.
# - BUILD_DEPS: Packages needed to build/install the project.
# - BUNDLE_VERSION_MATCH: Install the Bundler version used by the lockfile
#                         instead of using the SCL version.
# - BUNDLE_GEMFILE: Gemfile name to pin Bundler to.
# - BUNDLE_WITHOUT: List of Bundler groups to skip.
# - DELETE_UNUSED_GEMFILES: Deletes unused Gemfiles in the root directory.
# - CONFIG_SAAS: true for a SaaS image. false for an on-premises image.
# - PUMA_WORKERS: Default number of Puma workers to serve the app.
#
# Profiles you should use:
#
# You can use variations on the values of arguments, but you usually want one
# of the following two use cases:
#
# - Development/Test: just use default values.
# - Release:
#   - GEM_UPDATE: false
#   - BUNDLE_VERSION_MATCH: false
#   - BUNDLE_GEMFILE: Gemfile for SaaS, Gemfile.on_prem for on-premises.
#   - BUNDLE_WITHOUT: development:test
#   - DELETE_UNUSED_GEMFILES: true
#   - CONFIG_SAAS: true for SaaS, false for on-premises.
#   - PUMA_WORKERS: number of Puma worker processes - depends on intended usage,
#                   with number of cpus being a good heuristic.
#

FROM registry.access.redhat.com/ubi8/ubi-minimal

ENV HOME=/home
WORKDIR "${HOME}/app"

ARG RUBY_VERSION="2.7"
ARG RUNTIME_DEPS="ruby"

RUN echo -e "[ruby]\nname=ruby\nstream=${RUBY_VERSION}\nprofiles=\nstate=enabled\n" > /etc/dnf/modules.d/ruby.module \
 && microdnf update --nodocs \
 && microdnf install --nodocs ${RUNTIME_DEPS} \
 && chown -R 1001:1001 "${HOME}"

ARG BUILD_DEPS="tar make file findutils git patch gcc automake autoconf libtool redhat-rpm-config openssl-devel ruby-devel"

RUN microdnf install --nodocs ${BUILD_DEPS}

# Bundler should be kept as-is for productisation
ARG BUNDLE_VERSION_MATCH=true
# If the above is false
ARG BUNDLE_VERSION="2.2.9"

ARG BUNDLE_GEMFILE=Gemfile.on_prem
ARG BUNDLE_WITHOUT=development:test

COPY --chown=1001:1001 ${BUNDLE_GEMFILE}.lock "${HOME}/app/"

RUN mkdir -p "${HOME}/.gem/bin" \
 && echo "gem: --bindir ~/.gem/bin" > "${HOME}/.gemrc"

RUN gem uninstall --executables bundler \
 && BUNDLED_WITH=$(cat ${BUNDLE_GEMFILE}.lock | \
      grep -A 1 "^BUNDLED WITH$" | tail -n 1 | sed -e 's/\s//g') \
 && if test "${BUNDLE_VERSION_MATCH}x" = "truex"; then \
      gem install -N bundler --version "${BUNDLED_WITH}"; \
    else \
      gem install -N bundler --version "${BUNDLE_VERSION}"; \
    fi \
 && echo Using $(bundle --version), originally bundled with ${BUNDLED_WITH} \
 && bundle config --local silence_root_warning 1 \
 && bundle config --local disable_shared_gems 1 \
 && bundle config --local without ${BUNDLE_WITHOUT} \
 && bundle config --local gemfile ${BUNDLE_GEMFILE}

# Copy sources
COPY --chown=1001:1001 ./ "${HOME}/app/"

ARG DELETE_UNUSED_GEMFILES=true
# Turn off for productisation
ARG CONFIG_SAAS=false

# Builds a clean source tree and deploys it with Bundler.
# Sets the right configuration and permissions.