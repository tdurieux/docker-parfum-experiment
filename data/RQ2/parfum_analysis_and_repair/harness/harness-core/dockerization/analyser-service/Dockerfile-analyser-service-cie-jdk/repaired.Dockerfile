# Copyright 2022 Harness Inc. All rights reserved.
# Use of this source code is governed by the PolyForm Free Trial 1.0.0 license
# that can be found in the licenses directory at the root of this repository, also available at
# https://polyformproject.org/wp-content/uploads/2020/05/PolyForm-Free-Trial-1.0.0.txt.

# To be used when building in CIE

FROM us.gcr.io/platform-205701/ubi/ubi-java:latest as base

# Add the capsule JAR and config.yml
COPY --chown=65534:65534 analyser-service-capsule.jar /opt/harness/
COPY --chown=65534:65534 config.yml /opt/harness/
COPY --chown=65534:65534 keystore.jks /opt/harness/
COPY --chown=65534:65534 protocol.info /opt/harness/

COPY --chown=65534:65534 scripts /opt/harness

CMD [ "./run.sh" ]


############################ON PREM#########################
FROM base as onprem

COPY --chown=65534:65534 inject-onprem-apm-bins-into-dockerimage.sh /opt/harness
RUN /opt/harness/inject-onprem-apm-bins-into-dockerimage.sh && rm /opt/harness/inject-onprem-apm-bins-into-dockerimage.sh


############################SAAS#########################