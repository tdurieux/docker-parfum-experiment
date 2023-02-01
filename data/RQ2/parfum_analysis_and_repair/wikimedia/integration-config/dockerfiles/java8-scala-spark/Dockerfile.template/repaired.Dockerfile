FROM {{ "maven-java8" | image_tag }}

USER root

COPY KEYS /etc/apt/trusted.gpg.d/scalabt.asc

ENV SBT_VERSION=1.2.8


RUN cd /tmp \
    && {{ "curl" | apt_install }} \
    && curl -fsLO https://scala.jfrog.io/artifactory/debian/sbt-$SBT_VERSION.deb \
    && dpkg -i sbt-$SBT_VERSION.deb \
    && apt purge --yes curl \
    && rm /tmp/sbt*

# TODO: Would be nice to download scala here rather than at runtime, but I
# can't find signed binaries.

COPY sbtopts /etc/sbt/sbtopts

USER nobody
WORKDIR /workspace/src

COPY run.sh /run.sh
ENTRYPOINT [ "/run.sh" ]