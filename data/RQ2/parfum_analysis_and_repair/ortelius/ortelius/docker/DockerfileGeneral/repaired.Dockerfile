FROM quay.io/openmake/meister:v7_5_1 AS builder

WORKDIR /build/

COPY . /workspace
RUN /workspace/tgt/build-gen.sh

FROM quay.io/ortelius/ms-java-base:fedora-34-java-8-v1_0_0
EXPOSE 8080
ENV DBHome /opt/deployhub
ENV DBConnectionString jdbc:postgresql://db.ortelius.io:80/postgres
ENV DBDriverName org.postgresql.Driver

WORKDIR /opt/deployhub/webadmin/

COPY --from=builder /workspace/installers/linux/webadmin/webapp-runner.jar webapp-runner.jar
COPY --from=builder /build/dh-ms-general.war  dh-ms-general.war
RUN pip install --no-cache-dir --upgrade deployhub
ENTRYPOINT /usr/bin/java -jar /opt/deployhub/webadmin/webapp-runner.jar --path /dmadminweb /opt/deployhub/webadmin/dh-ms-general.war 2>&1
