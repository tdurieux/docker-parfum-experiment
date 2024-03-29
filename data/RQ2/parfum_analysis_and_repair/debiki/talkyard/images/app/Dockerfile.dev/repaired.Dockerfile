FROM openjdk:8u212-jdk-alpine3.9

RUN apk add --no-cache \
  # Required:
  # (git needed so can include Git revision in the build,
  # and show at http://server/-/build-info.)
  curl unzip git \
  # For PASETO v2.local tokens, needs XChaCha20Poly1305:
  libsodium \
  # Nice to have:
  tree less wget net-tools bash \
  # tput, needed by Coursier somehow
  ncurses \
  # Telnet, nice for troubleshooting SMTP problems for example.
  busybox-extras

# ADD extracts tar archives; this .tgz gets unpacked at /opt/sbt/{bin/,conf/}.
ADD  sbt/sbt-1.4.5.tgz  /opt/

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

# Don't do until now, so won't need to rebuild whole image if editing entrypoint.
COPY entrypoint.dev.sh /docker-entrypoint.sh
RUN  chmod ugo+x   /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

# Overriden in docker-compose.yml
ENV PLAY_HEAP_MEMORY_MB 1048



# ------------------------------------------------------------
# SBT options, as of 2020-12-20:  (d/c exec app bash ; cd /opt/sbt/bin ; ./sbt -h)
# ------------------------------------------------------------
# Usage: sbt [options]
#
#   -h | --help         print this message
#   -v | --verbose      this runner is chattier
#   -V | --version      print sbt version information
#   --numeric-version   print the numeric sbt version (sbt sbtVersion)
#   --script-version    print the version of sbt script
#   -d | --debug        set sbt log level to debug
#   -debug-inc | --debug-inc
#                       enable extra debugging for the incremental debugger
#   --no-colors         disable ANSI color codes
#   --color=auto|always|true|false|never
#                       enable or disable ANSI color codes      (sbt 1.3 and above)
#   --supershell=auto|always|true|false|never
#                       enable or disable supershell            (sbt 1.3 and above)
#   --traces            generate Trace Event report on shutdown (sbt 1.3 and above)
#   --timings           display task timings report on shutdown
#   --sbt-create        start sbt even if current directory contains no sbt project
#   --sbt-dir   <path>  path to global settings/plugins directory (default: ~/.sbt)
#   --sbt-boot  <path>  path to shared boot directory (default: ~/.sbt/boot in 0.11 series)
#   --ivy       <path>  path to local Ivy repository (default: ~/.ivy2)
#   --mem    <integer>  set memory options (default: 1024)
#   --no-share          use all local caches; no sharing
#   --no-global         uses global caches, but does not use global ~/.sbt directory.
#   --jvm-debug <port>  Turn on JVM debugging, open at the given port.
#   --batch             disable interactive mode
#
#   # sbt version (default: from project/build.properties if present, else latest release)
#   --sbt-version  <version>   use the specified version of sbt
#   --sbt-jar      <path>      use the specified jar as the sbt launcher
#
#   # java version (default: java from PATH, currently openjdk version "1.8.0_212")
#   --java-home <path>         alternate JAVA_HOME
#
#   # jvm options and output control
#   JAVA_OPTS           environment variable, if unset uses "-Dfile.encoding=UTF-8"
#   .jvmopts            if this file exists in the current directory, its contents
#                       are appended to JAVA_OPTS
#   SBT_OPTS            environment variable, if unset uses ""
#   .sbtopts            if this file exists in the current directory, its contents
#                       are prepended to the runner args
#   /etc/sbt/sbtopts    if this file exists, it is prepended to the runner args
#   -Dkey=val           pass -Dkey=val directly to the java runtime
#   -J-X                pass option -X directly to the java runtime
#                       (-J is stripped)
#   -S-X                add -X to sbt's scalacOptions (-S is stripped)
#
# In the case of duplicated or conflicting options, the order above
# shows precedence: JAVA_OPTS lowest, command line options highest.
# ------------------------------------------------------------


# Set Java's user.home env var to /home/owner so sbt will cache downloads there, [SBTHOME]
# more specifically, in /home/owner/.cache/coursier/.
# Although user.home is set in entrypoint.sh, apparently that setting gets lost here —
# sbt then downloads things to /root/.sbt and /root/.ivy2 if running as root inside a vm.
# Maybe because of 'exec'?
#
CMD cd /opt/talkyard/app/ && exec /opt/sbt/bin/sbt \
  --mem $PLAY_HEAP_MEMORY_MB \
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
  # log4j2 problem, disable this:
  -Dlog4j2.formatMsgNoLookups=true \
  #
  -Dconfig.file=/opt/talkyard/app/conf/app-dev.conf \
  run