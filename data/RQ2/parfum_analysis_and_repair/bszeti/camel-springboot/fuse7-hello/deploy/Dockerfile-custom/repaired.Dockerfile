FROM overwritten-from-buildconfig
# mkdir to advance to avoid permission issues
RUN mkdir /tmp/src
WORKDIR /tmp/src
COPY --chown=jboss . .
# Just to check everything we have
RUN pwd && ls -las
RUN mvn clean package -Dmaven.repo.local=/tmp/localrepo && \
    mv target/*.jar /deployments/ && \
    rm -rf /tmp/src