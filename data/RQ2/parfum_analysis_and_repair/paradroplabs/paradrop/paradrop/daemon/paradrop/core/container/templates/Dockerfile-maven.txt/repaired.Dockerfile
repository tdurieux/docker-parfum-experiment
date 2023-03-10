FROM {image}

# Set up an unprivileged user so that we can drop out of root.
# Make /home/paradrop so that npm can drop some files in there.
# Make /opt/paradrop/app for installing the app files.
RUN useradd --system --uid 999 paradrop && \
    mkdir -p /home/paradrop && \
    chown paradrop /home/paradrop && \
    mkdir -p /opt/paradrop/app && \
    chown paradrop /opt/paradrop/app && \
    chmod a+s /opt/paradrop/app

WORKDIR /opt/paradrop/app

# Add cap_net_bind_service to node so that it can bind to ports 1-1024.
# Not all images support this.
RUN setcap 'cap_net_bind_service=+ep' /usr/local/bin/node || true

{has_packages:if:RUN apt-get install -y {packages}}

# Defang setuid/setgid binaries.
RUN find / -perm +6000 -type f -exec chmod a-s {{}} \; || true

# The default directory (/root/.m2) is not writable by paradrop user.
# The logger option makes maven a little less verbose.
ENV MAVEN_CONFIG=/opt/paradrop/.m2 \
    MAVEN_OPTS="-Dorg.slf4j.simpleLogger.log.org.apache.maven.cli.transfer.Slf4jMavenTransferListener=warn -Dmaven.test.skip=true"

# Copy paradrop.yaml and pom.xml, the latter only if it exists.  These
# layers will be cached as long as the requirements do not change.
COPY paradrop.yaml pom.xm[l] /opt/paradrop/app/
RUN if [ -f pom.xml ]; then mvn --batch-mode dependency:resolve; fi

# Now copy the files.
COPY . /opt/paradrop/app/
RUN mvn --batch-mode package
RUN chown paradrop:paradrop -R /opt/paradrop/app

{drop_root:if:USER paradrop}

CMD {cmd}