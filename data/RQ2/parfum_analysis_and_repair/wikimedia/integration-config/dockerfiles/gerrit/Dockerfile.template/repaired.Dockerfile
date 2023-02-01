# Docker image with gerrit

FROM {{ "maven" | image_tag }} AS maven

FROM {{ "bazelisk" | image_tag }}

USER root

# Gerrit plugins might rely on Maven to ship dependencies.
ENV MAVEN_BIN=/opt/apache-maven/bin/mvn
COPY --from=maven /opt/apache-maven /opt/apache-maven
COPY --from=maven /usr/local/bin/mvn /usr/local/bin/mvn
COPY --from=maven /settings.xml /settings.xml

# We need both Java 8 and 11
RUN echo "deb http://apt.wikimedia.org/wikimedia buster-wikimedia component/jdk8" \
        > /etc/apt/sources.list.d/buster-jdk8.list \
    && mkdir -p /usr/share/man/man1 \
    && {{ "openjdk-8-jdk-headless openjdk-11-jdk-headless" | apt_install }}

# Setting home dir for Gerrit tools/download_file.py which uses ~ for caching
# downloaded artifacts
ENV GERRIT_CACHE_HOME="$XDG_CACHE_HOME/gerrit"

# Bower writes some stuff there:
ENV XDG_DATA_HOME=/tmp/data

RUN {{ "nodejs" | apt_install }} \
    && git clone --depth 1 https://gerrit.wikimedia.org/r/p/integration/npm.git /srv/npm \
    && rm -rf /srv/npm/.git \
    && ln -s /srv/npm/bin/npm-cli.js /usr/bin/npm

# gcc for asciidoctor
# curl is required by Gerrit tools/download_file.py
# zip and unzip by src/tools/js/download_bower.py