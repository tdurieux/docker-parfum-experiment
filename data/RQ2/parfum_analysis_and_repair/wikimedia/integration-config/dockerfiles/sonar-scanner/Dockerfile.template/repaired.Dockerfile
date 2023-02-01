FROM {{ "maven-java11" | image_tag }}

USER root
COPY KEYS /tmp/KEYS

ENV SONAR_SCANNER_VERSION=4.6.0.2311

ENV NODE_VERSION=v14.17.5-linux-x64

RUN {{ "gnupg wget unzip curl jq" | apt_install }}

COPY SHASUMS256.txt /tmp/nodeinstall/SHASUMS256.txt
RUN cd /tmp/nodeinstall \
    && curl -f -Lo node-${NODE_VERSION}.tar.gz https://nodejs.org/dist/v14.17.5/node-${NODE_VERSION}.tar.gz \
    && grep node-${NODE_VERSION}.tar.gz SHASUMS256.txt | sha256sum -c - \
    && tar -xzf node-${NODE_VERSION}.tar.gz \
    && mv node-${NODE_VERSION}/bin/node /usr/bin/node \
    && ln -s /usr/bin/node /usr/bin/nodejs \
    && mv node-${NODE_VERSION}/share/ /usr/share/nodejs \
    && mv node-${NODE_VERSION}/include/node /usr/include/node \
    && rm -rf /tmp/nodeinstall && rm node-${NODE_VERSION}.tar.gz

# Pin our Node 14 image to npm 7.x. Official Node.js 14 tarballs come with npm 6,
# but, we upgraded npm and we're sticking to it.
RUN git clone --depth 1 https://gerrit.wikimedia.org/r/integration/npm.git -b npm-7.21.0 /srv/npm \
    && rm -rf /srv/npm/.git \
    && ln -s /srv/npm/bin/npm-cli.js /usr/bin/npm \
    && ln -s /srv/npm/bin/npx-cli.js /usr/bin/npx

# Slight digression compared to node10
ENV NPM_CONFIG_CACHE=/cache/npm
ENV GNUPGHOME=/tmp

RUN cd /tmp \
    && wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-$SONAR_SCANNER_VERSION.zip \
    && wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-$SONAR_SCANNER_VERSION.zip.asc \
    && gpg --batch --import /tmp/KEYS \
    && gpg --batch --verify sonar-scanner-cli-$SONAR_SCANNER_VERSION.zip.asc \
    && unzip sonar-scanner-cli-$SONAR_SCANNER_VERSION.zip \
    && mv sonar-scanner-$SONAR_SCANNER_VERSION /opt/sonar-scanner \
    && apt purge --yes gnupg wget unzip && rm sonar-scanner-cli-$SONAR_SCANNER_VERSION.zip.asc

USER nobody
WORKDIR /workspace/src

COPY run-php.sh /run-php.sh
COPY run-java.sh /run-java.sh
COPY run.sh /run.sh
CMD [ "--version" ]
ENTRYPOINT [ "/run-php.sh" ]
