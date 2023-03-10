FROM alpine:3.14.2
LABEL deepfence.role=system
ENV VERSION=v10.19.0 NPM_VERSION=6 YARN_VERSION=latest
# ENV VERSION=v10.18.1 NPM_VERSION=6 YARN_VERSION=latest
# ENV VERSION=v12.14.1 NPM_VERSION=6 YARN_VERSION=latest
# ENV VERSION=v13.6.0 NPM_VERSION=6 YARN_VERSION=latest
# For base builds
# ENV CONFIG_FLAGS="--fully-static --without-npm" DEL_PKGS="libstdc++" RM_DIRS=/usr/include
RUN apk upgrade --no-cache -U && \
  apk add --no-cache curl make gcc g++ python2 linux-headers binutils-gold gnupg libstdc++
RUN for server in keys.openpgp.org keyserver.pgp.com pgp.mit.edu keyserver.ubuntu.com; do \
    gpg --batch --keyserver $server --recv-keys \
      4ED778F539E3634C779C87C6D7062848A1AB005C \
      B9E2F5981AA6E0CD28160D9FF13993A75599653C \
      94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
      B9AE9905FFD7803F25714661B63B535A4C206CA9 \
      77984A986EBC2AA786BC0F66B01FBB92821C587A \
      71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
      FD3A5288F042B6850C66B31F09FE44734EB7990E \
      8FCCA13FEF1D0C2E91008E09770F7A9A5AE15600 \
      C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
      DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
      A48C2BEE680E841632CD4E44F07496B3EB3C1762 && break; \
  done
RUN curl -sfSLO https://nodejs.org/dist/${VERSION}/node-${VERSION}.tar.xz && \
  curl -sfSL https://nodejs.org/dist/${VERSION}/SHASUMS256.txt.asc | gpg --batch -d -o SHASUMS256.txt && \
  grep " node-${VERSION}.tar.xz\$" SHASUMS256.txt | sha256sum -c | grep ': OK$' && \
  tar -xf node-${VERSION}.tar.xz && \
  cd node-${VERSION} && \
  ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr ${CONFIG_FLAGS} && \
  make -j$(getconf _NPROCESSORS_ONLN) && \
  make install && rm node-${VERSION}.tar.xz
RUN if [ -z "$CONFIG_FLAGS" ]; then \
    if [ -n "$NPM_VERSION" ]; then \
      npm install -g npm@${NPM_VERSION}; npm cache clean --force; \
    fi; \
    find /usr/lib/node_modules/npm -type d \( -name test -o -name .bin \) | xargs rm -rf; \
    apk add --no-cache yarn && rm -rf /var/cache/apk/*; \
  fi;
RUN apk del curl make gcc g++ python2 linux-headers binutils-gold gnupg ${DEL_PKGS} && \
  rm -rf ${RM_DIRS} /node-${VERSION}* /SHASUMS256.txt /tmp/* \
    /usr/share/man/* /usr/share/doc /root/.npm /root/.node-gyp /root/.config \
    /usr/lib/node_modules/npm/man /usr/lib/node_modules/npm/doc /usr/lib/node_modules/npm/docs \
    /usr/lib/node_modules/npm/html /usr/lib/node_modules/npm/scripts && \
  { rm -rf /root/.gnupg || true; }
