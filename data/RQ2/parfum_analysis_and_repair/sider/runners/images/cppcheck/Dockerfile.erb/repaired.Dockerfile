FROM python:3-slim-buster AS cppcheck

# NOTE: The reason using Python image: when setting `MATCHCOMPILER=yes`, Python is used to optimise cppcheck.
#       See <https://github.com/danmar/cppcheck/blob/6cb8f877981a491465aba2f9ffb00d6142f6f852/readme.md#gnu-make>

ARG CPPCHECK_VERSION=2.6.3

# NOTE: A segmentation fault occurs with the latest version of libz3.
ARG LIBZ3_VERSION=4.4.1-1~deb10u1

RUN apt-get update && \
    apt-get install -qq -y --no-install-recommends \
      curl \
      g++ \
      make \
      libpcre3-dev \
      "libz3-dev=${LIBZ3_VERSION}" && \
    rm -rf /var/lib/apt/lists/* && \
    cd /tmp && \
    curl -f -sSL --compressed "https://github.com/danmar/cppcheck/archive/${CPPCHECK_VERSION}.tar.gz" | tar -xz && \
    cd "cppcheck-${CPPCHECK_VERSION}" && \
    # NOTE: We cannot use the latest version due to a potential segmentation fault.
    cp -v externals/z3_version_old.h externals/z3_version.h && \
    make "-j$(nproc)" --silent install \
      MATCHCOMPILER=yes \
      PREFIX=/opt/cppcheck \
      FILESDIR=/opt/cppcheck/share \
      HAVE_RULES=yes \
      USE_Z3=yes \
      CXXFLAGS="-O2 -DNDEBUG -Wall -Wno-sign-compare -Wno-unused-function"

FROM sider/devon_rex_base:2.46.0

<%= render_erb 'images/Dockerfile.base.erb' %>

# See above.
ARG LIBZ3_VERSION=4.4.1-1~deb10u1

USER root
RUN apt-get update && \
    apt-get install -qq -y --no-install-recommends \
      "libz3-dev=${LIBZ3_VERSION}" && \
    rm -rf /var/lib/apt/lists/*
COPY --from=cppcheck /opt/cppcheck /opt/cppcheck
ENV PATH /opt/cppcheck/bin:${PATH}

COPY --chown=<%= chown %> images/<%= analyzer %>/sider_recommended_cppcheck.txt ${RUNNER_USER_HOME}/

<%= render_erb 'images/Dockerfile.end.erb' %>
