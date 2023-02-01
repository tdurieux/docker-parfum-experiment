# Copyright 2022 Harness Inc. All rights reserved.
# Use of this source code is governed by the PolyForm Free Trial 1.0.0 license
# that can be found in the licenses directory at the root of this repository, also available at
# https://polyformproject.org/wp-content/uploads/2020/05/PolyForm-Free-Trial-1.0.0.txt.

# To be used when building in CIE

FROM us.gcr.io/platform-205701/ubi/ubi-java:latest

# Add the capsule JAR and config.yml
COPY delegate-service-capsule.jar keystore.jks delegate-service-config.yml redisson-jcache.yaml /opt/harness/

COPY scripts /opt/harness

RUN set -x \
# create required files and directories
    && mkdir /opt/harness/plugins \
    && mkdir /opt/harness/logs \
# forward manager logs to docker log collector
    && ln -sfT /dev/stdout /opt/harness/logs/delegate-service.log \
# setup user and file permissions