FROM maven

COPY pom.xml /tmp/provisioner/pom.xml

WORKDIR /tmp/provisioner/

RUN mvn package

COPY /src/ /tmp/provisioner/src/

RUN mvn clean package dependency:copy-dependencies -DskipTests -DincludeScope=runtime


FROM tier/gte:base-201911

COPY docker-test/conf/ /opt/grouper/conf/
COPY docker-test/GoogleProvisioner.p12 /
COPY docker-test/testInit.gsh /

COPY --from=0 /tmp/provisioner/target/lib/ /opt/grouper/grouper.apiBinary/lib/custom/
COPY --from=0 /tmp/provisioner/target/google-*.jar /opt/grouper/grouper.apiBinary/lib/custom/

RUN set -x; \
    (/usr/sbin/slapd -h "ldap:/// ldaps:/// ldapi:///" -u ldap &) \
    && while !curl -f -s ldap://localhost:389 > /dev/null; ; do do echo waiting for ldap to start; sleepdone; \
    (mysqld_safe & ) \
    && while !curl -f -s localhost:3306 > /dev/null; ; do do echo waiting for mysqld to start; sleepdone; \
    . /usr/local/bin/library.sh \
    && prepConf \
    bin/gsh /testInit.gsh \
    && bin/gsh -main edu.internet2.middleware.changelogconsumer.googleapps.GoogleAppsFullSync courses \
    && pkill -HUP slapd \
    && while curl -f -s ldap://localhost:389 > /dev/null; ; do do echo waiting for ldap to stop; sleepdone; \
    pkill -u mysql mysqld \
    && while curl -f -s localhost:3306 > /dev/null; ; do do echo waiting for mysqld to stop; sleepdone
