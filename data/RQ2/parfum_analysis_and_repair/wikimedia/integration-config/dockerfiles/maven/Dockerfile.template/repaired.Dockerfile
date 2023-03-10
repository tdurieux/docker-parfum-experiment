# Scratch container containing Maven

FROM {{ "ci-buster" | image_tag }} AS build

# Install a more recent Maven version
COPY KEYS /tmp/KEYS
COPY apache-maven-3.5.2-bin.tar.gz.asc /tmp/apache-maven-3.5.2-bin.tar.gz.asc
RUN {{ "gnupg wget" | apt_install }} \
    && cd /tmp \
    && wget https://repo.maven.apache.org/maven2/org/apache/maven/apache-maven/3.5.2/apache-maven-3.5.2-bin.tar.gz \
    && gpg --batch --import /tmp/KEYS \
    && rm /tmp/KEYS \
    && gpg --batch --verify apache-maven-3.5.2-bin.tar.gz.asc \
    && tar -C /opt -zxf apache-maven-3.5.2-bin.tar.gz \
    && mv /opt/apache-maven* /opt/apache-maven \
    && apt purge --yes gnupg wget \
    && rm -f /tmp/apache-maven* \
    && rm -rf ~/.gnupg && rm apache-maven-3.5.2-bin.tar.gz

# The basic scratch image with all the materials
FROM scratch
COPY --from=build /opt/apache-maven /opt/apache-maven
COPY mvn /usr/local/bin/mvn
COPY settings.xml /settings.xml
COPY run.sh /run.sh
