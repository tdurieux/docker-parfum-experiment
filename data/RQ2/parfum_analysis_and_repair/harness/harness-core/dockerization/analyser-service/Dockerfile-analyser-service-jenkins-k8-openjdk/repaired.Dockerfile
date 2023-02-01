# to be used when building in Jenkins
FROM us.gcr.io/platform-205701/alpine:safe-alpine3.15.4-bt1276

# Add the capsule JAR and config.yml
COPY analyser-service-capsule.jar config.yml keystore.jks /opt/harness/

RUN wget https://github.com/mikefarah/yq/releases/download/3.3.2/yq_linux_amd64 -O /usr/bin/yq -O /usr/bin/yq
RUN chmod +x /usr/bin/yq

# Add the capsule JAR and config.yml