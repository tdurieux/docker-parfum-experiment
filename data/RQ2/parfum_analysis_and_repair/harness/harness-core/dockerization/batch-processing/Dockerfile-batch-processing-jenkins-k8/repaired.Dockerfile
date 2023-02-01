# to be used when building in Jenkins
FROM harness/serverjre_8:191
RUN yum install -y hostname tar gzip python3 && rm -rf /var/cache/yum

# Add the capsule JAR and config.yml
COPY batch-processing-capsule.jar batch-processing-config.yml  /opt/harness/

## # install yq - a YAML query command line tool
RUN curl -f -Lso yq https://github.com/mikefarah/yq/releases/download/2.2.1/yq_linux_amd64
RUN chmod +x yq
RUN mv yq /usr/local/bin

RUN pip3 install --no-cache-dir awscli

#AzCopy installation
RUN curl -f -LO https://aka.ms/downloadazcopy-v10-linux && tar -xvf downloadazcopy-v10-linux && cp ./azcopy_linux_amd64_*/azcopy /usr/local/bin/

# Add AWS S3 transfer config
RUN aws configure set default.s3.max_concurrent_requests 20
RUN aws configure set default.s3.multipart_chunksize 16MB

COPY scripts /opt/harness

RUN chmod +x /opt/harness/*.sh
RUN mkdir -p /opt/harness/plugins

WORKDIR /opt/harness

CMD [ "./run.sh" ]
