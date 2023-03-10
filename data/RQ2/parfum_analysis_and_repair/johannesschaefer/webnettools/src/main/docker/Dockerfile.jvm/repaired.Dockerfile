FROM registry.access.redhat.com/ubi8/ubi-minimal:8.3

ARG JAVA_PACKAGE=java-11-openjdk-headless
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en'
# Install java and the run-java script
# Also set up permissions for user `1001`
RUN microdnf install util-linux procps bind-utils hostname iputils curl ca-certificates tar git nmap ${JAVA_PACKAGE} \
    && curl -f https://bintray.com/ookla/rhel/rpm -o bintray-ookla-rhel.repo && mv bintray-ookla-rhel.repo /etc/yum.repos.d/ && microdnf install speedtest \
    && microdnf update \
    && microdnf clean all \
    && rpm -i https://rpmfind.net/linux/centos/8-stream/BaseOS/x86_64/os/Packages/traceroute-2.1.0-6.el8.x86_64.rpm \
    && rpm -i http://mirror.centos.org/centos/8/BaseOS/x86_64/os/Packages/mtr-0.92-3.el8.x86_64.rpm \
    && mkdir /deployments \
    && chown 1001 /deployments \
    && chmod "g+rwX" /deployments \
    && chown 1001:root /deployments \
    && echo "securerandom.source=file:/dev/urandom" >> /etc/alternatives/jre/lib/security/java.security \
    && git clone --depth 1 https://github.com/drwetter/testssl.sh.git \
    && setcap cap_net_raw+eip /usr/bin/nmap
     #\
    #&& mkdir -p /root/.config/ookla \
   # && echo -e "{\n" \
   #      "     \"Settings\": {\n" \
   #      "         \"LicenseAccepted\": \"604ec27f828456331ebf441826292c49276bd3c1bee1a2f65a6452f505c4061c\",\n" \
   #      "         \"GDPRTimeStamp\": 1615738481\n" \
   #      "     }\n" \
   #      "}\n" > /root/.config/ookla/speedtest-cli.json

ENV PATH=/testssl.sh:$PATH

ENV AVAILABLE_TOOLS=testssl,ping,traceroute,nmap,dig,mtr
ENV RATE_LIMIT=1
ENV CA_DIR=/certs

# Configure the JAVA_OPTIONS, you can add -XshowSettings:vm to also display the heap size.
ENV JAVA_OPTIONS="-Dquarkus.http.host=0.0.0.0 -Djava.util.logging.manager=org.jboss.logmanager.LogManager"
COPY target/lib/* /deployments/lib/
COPY target/*-runner.jar /deployments/app.jar

EXPOSE 8080
USER 1001

ENV PORT=8080

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s \
  CMD curl -f http://localhost:8080/q/health/live || exit 1

ENTRYPOINT [ "java" ]
CMD [ "-Dquarkus.http.host=0.0.0.0", "-Dquarkus.http.port=${PORT}", "-jar", "/deployments/app.jar", "-Djava.util.logging.manager=org.jboss.logmanager.LogManager" ]