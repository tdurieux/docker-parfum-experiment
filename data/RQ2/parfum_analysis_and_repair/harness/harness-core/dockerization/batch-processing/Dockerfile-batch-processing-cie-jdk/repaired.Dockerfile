# Copyright 2022 Harness Inc. All rights reserved.
# Use of this source code is governed by the PolyForm Free Trial 1.0.0 license
# that can be found in the licenses directory at the root of this repository, also available at
# https://polyformproject.org/wp-content/uploads/2020/05/PolyForm-Free-Trial-1.0.0.txt.

FROM us.gcr.io/platform-205701/ubi/ubi-java:latest as base
USER root
RUN yum install -y hostname tar gzip python3 && rm -rf /var/cache/yum

# Add the capsule JAR and config.yml
COPY --chown=65534:65534 batch-processing-capsule.jar /opt/harness/
COPY --chown=65534:65534 batch-processing-config.yml  /opt/harness/
COPY --chown=65534:65534 protocol.info /opt/harness/

RUN pip3 install --no-cache-dir awscli

#Download AzCopy
RUN curl -f -LO https://aka.ms/downloadazcopy-v10-linux && tar -xvf downloadazcopy-v10-linux && cp ./azcopy_linux_amd64_*/azcopy /usr/local/bin/ \
    && chmod +x /usr/local/bin/azcopy

# Add AWS S3 transfer config
RUN aws configure set default.s3.max_concurrent_requests 20
RUN aws configure set default.s3.multipart_chunksize 16MB

ENV AZCOPY_LOG_LOCATION=/opt/harness/azlogs

COPY --chown=65534:65534 scripts /opt/harness

CMD [ "./run.sh" ]

USER 65534

############################ON PREM#########################
FROM base as onprem

COPY --chown=65534:65534 inject-onprem-apm-bins-into-dockerimage.sh /opt/harness
RUN /opt/harness/inject-onprem-apm-bins-into-dockerimage.sh && rm /opt/harness/inject-onprem-apm-bins-into-dockerimage.sh


############################SAAS#########################
FROM base as saas

COPY --chown=65534:65534 inject-saas-apm-bins-into-dockerimage.sh /opt/harness
RUN /opt/harness/inject-saas-apm-bins-into-dockerimage.sh && rm -rf /opt/harness/inject-saas-apm-bins-into-dockerimage.sh