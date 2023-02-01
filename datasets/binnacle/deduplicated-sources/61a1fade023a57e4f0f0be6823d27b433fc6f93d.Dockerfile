FROM openjdk:8u212-jdk-alpine3.9

RUN apk add --no-cache \
  # Required:
  # (git needed so can include Git revision in the build, and show at http://server/-/build-info.)
  curl unzip git \
  # Nice to have:
  tree less wget net-tools bash \
  # Telnet, nice for troubleshooting SMTP problems for example.
  busybox-extras

ENV ACVERSION 1.3.12
ENV ACTIVATOR activator-$ACVERSION

RUN \
  curl https://downloads.typesafe.com/typesafe-activator/$ACVERSION/typesafe-$ACTIVATOR-minimal.zip \
    > /tmp/$ACTIVATOR.zip

# Concerning +rw for /opt/typesafe-activator/: Play writes some files to directories
# within the archive. Otherwise:
#   Error during sbt execution: java.io.IOException: No such file or directory
#   see: http://stackoverflow.com/questions/10559313/play-framework-installation
RUN unzip /tmp/$ACTIVATOR.zip -d /tmp/ && \
    rm -f /tmp/$ACTIVATOR.zip && \
    mkdir -p /opt/ && \
    mv /tmp/activator-$ACVERSION-minimal /opt/typesafe-activator && \
    chmod -R ugo+rw /opt/typesafe-activator/ && \
    chmod -R ugo+x /opt/typesafe-activator/bin/activator

# Install 'gosu' so we can use it instead of 'su'.
# For unknown reasons, '  exec su ...' no longer works, but 'exec gosu ...' works fine.
RUN apk add --no-cache \
  --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ \
  gosu

# Play's HTTP and HTTPS listen ports, Java debugger port, JMX port 3333.
EXPOSE 9000 9443 9999 3333

RUN mkdir -p /opt/talkyard/uploads/ && \
    chmod -R ugo+rw /opt/talkyard/uploads/

# Add a self signed dummy cert for the dummy SMTP server (the 'fakemail' Docker container),
# so one can test connecting to it with TLS and see if the TLS conf vals work. [26UKWD2]
# ("changeit" = default keystore password)
COPY fakemail-publ-test-self-signed.crt /smtp-server.crt
RUN cd $JAVA_HOME/jre/lib/security && \
    keytool -keystore cacerts -storepass changeit -noprompt -trustcacerts \
        -importcert -alias ldapcert -file /smtp-server.crt

WORKDIR /opt/talkyard/app/

COPY entrypoint.dev.sh /docker-entrypoint.sh
RUN  chmod ugo+x   /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

# Overriden in docker-compose.yml
ENV PLAY_HEAP_MEMORY_MB 1048

# Set Java's user.home to /home/owner so sbt and Ivy will cache downloads there. [SBTHOME]
# Although user.home is set in entrypoint.sh, apparently that setting gets lost here —
# sbt and Ivy download things to /root/.sbt and /root/.ivy2 if running as root inside a vm.
# Maybe because of 'exec'?
CMD cd /opt/talkyard/app/ && exec /opt/typesafe-activator/bin/activator \
  -mem $PLAY_HEAP_MEMORY_MB \
  -jvm-debug 9999 \
  # Avoid SBT compilation java.lang.StackOverflowError in
  # scala.tools.nsc.transform.Erasure.
  -J-Xss30m \
  -Duser.home=/home/owner \
   # see [30PUK42] in app-prod/Dockerfile
  -Djava.security.egd=file:/dev/./urandom \
  -Dcom.sun.management.jmxremote.port=3333 \
  -Dcom.sun.management.jmxremote.ssl=false \
  -Dcom.sun.management.jmxremote.authenticate=false \
  -Dhttp.port=9000 \
  -Dhttps.port=9443 \
  # SSL has security flaws. Use TLS instead. [NOSSL] [PROTOCONF]
  -Ddeployment.security.SSLv2Hello=false \
  -Ddeployment.security.SSLv3=false \
  -Dhttps.protocols=TLSv1.1,TLSv1.2 \
  -Djdk.tls.client.protocols=TLSv1.1,TLSv1.2 \
  -Dconfig.file=/opt/talkyard/app/conf/app-dev.conf \
  run

