FROM sider/devon_rex_base:2.46.0

<%= render_erb 'images/Dockerfile.base.erb' %>

COPY --chown=<%= chown %> images/<%= analyzer %>/packages.list /tmp/

ARG LLVM_VERSION=11

USER root

# NOTE: Do not remove apt caches. If doing so, runtime apt installation would not work.
# hadolint ignore=DL3009
RUN curl -fsSL https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && \
    add-apt-repository "deb http://apt.llvm.org/buster/ llvm-toolchain-buster-${LLVM_VERSION} main" && \
    apt-get update && \
    grep -v "^\s*#" /tmp/packages.list | xargs apt-get install -qq -y --no-install-recommends "clang-tidy-${LLVM_VERSION}" && \
    rm /tmp/packages.list && \
    update-alternatives --install /usr/local/bin/clang-tidy clang-tidy "/usr/lib/llvm-${LLVM_VERSION}/bin/clang-tidy" 20 && \
    clang-tidy --version | grep "LLVM version ${LLVM_VERSION}"

USER $RUNNER_USER

<%= render_erb 'images/Dockerfile.end.erb' %>