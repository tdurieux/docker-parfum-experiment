# to be used when building in Jenkins
FROM us.gcr.io/platform-205701/alpine:safe-alpine3.15.4-bt1276-apm
RUN apk add --no-cache tar gzip python3 py3-pip libc6-compat

# Add the capsule JAR and config.yml
COPY batch-processing-capsule.jar batch-processing-config.yml protocol.info /opt/harness/

RUN wget https://github.com/mikefarah/yq/releases/download/3.3.2/yq_linux_amd64 -O /usr/bin/yq -O /usr/bin/yq
RUN chmod +x /usr/bin/yq

RUN pip3 install --no-cache-dir awscli

#Download AzCopy
RUN curl -f -LO https://aka.ms/downloadazcopy-v10-linux && tar -xvf downloadazcopy-v10-linux && cp ./azcopy_linux_amd64_*/azcopy /usr/local/bin/

# Add AWS S3 transfer config
RUN aws configure set default.s3.max_concurrent_requests 20
RUN aws configure set default.s3.multipart_chunksize 16MB

COPY scripts /opt/harness

RUN chmod +x /opt/harness/*.sh
RUN mkdir -p /opt/harness/plugins

WORKDIR /opt/harness

CMD [ "./run.sh" ]
