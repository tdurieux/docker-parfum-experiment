ARG CC_DATABASE=sqlite

###############################################################################
#-----------------------------    BUILD STAGE   ------------------------------#
###############################################################################

FROM codecompass:dev as builder

ARG CC_VERSION=master
ENV CC_VERSION ${CC_VERSION}

ARG CC_DATABASE
ENV CC_DATABASE ${CC_DATABASE}

ARG CC_BUILD_TYPE=Release
ENV CC_BUILD_TYPE ${CC_BUILD_TYPE}

RUN apt-get update -qq && \
    apt-get install --yes git

# Download CodeCompass release.
RUN git clone https://github.com/Ericsson/CodeCompass.git /CodeCompass
WORKDIR /CodeCompass
RUN git checkout ${CC_VERSION}

# Build CodeCompass.
RUN mkdir /CodeCompass-build && \
  cd /CodeCompass-build && \
  cmake /CodeCompass \
    -DDATABASE=$CC_DATABASE \
    -DCMAKE_INSTALL_PREFIX=/CodeCompass-install \
    -DCMAKE_BUILD_TYPE=$CC_BUILD_TYPE \
    -DWITH_AUTH="plain;ldap" && \
  make -j $(nproc) && \
  make install

###############################################################################
#--------------------------    PRODUCTION STAGE   ----------------------------#
###############################################################################

FROM ubuntu:20.04

# tzdata package is installed implicitly in the following command. This package
# sets timezone interactively during the installation process. This environment
# variable prevents this interaction.
ARG DEBIAN_FRONTEND=noninteractive

ARG CC_DATABASE
ENV CC_DATABASE ${CC_DATABASE}

RUN if [ "pgsql" = "${CC_DATABASE}" ]; then \
    apt-get update -qq --yes && \
    apt-get install -qq --yes --no-install-recommends \
    postgresql-server-dev-12 \   
    libodb-pgsql-dev; \
    else \
    apt-get update -qq && \
    apt-get install -qq --yes --no-install-recommends \
    libsqlite3-dev \
    libodb-sqlite-dev; \
    fi;
    
RUN set -x && apt-get update -qq && \
    apt-get install -qq --yes --no-install-recommends \
    llvm-10 \
    libboost-filesystem-dev libboost-log-dev libboost-program-options-dev \
    default-jre \
    libgit2-dev \
    libssl1.1 \
    libgvc6 \
    libldap-2.4-2 \
    libmagic-dev \
    libthrift-dev \
    ctags \
    tini && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/ && \
    set +x


# Copy CodeCompass installed directory. (Change permission of the CodeCompass package.)
COPY --from=builder /CodeCompass-install /codecompass

ENV PATH="/codecompass/bin:$PATH"


ENTRYPOINT ["tini", "--"]

