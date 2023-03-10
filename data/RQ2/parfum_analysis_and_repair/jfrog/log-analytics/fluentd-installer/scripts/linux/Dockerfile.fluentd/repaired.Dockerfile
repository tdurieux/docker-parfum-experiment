FROM bitnami/fluentd:latest
LABEL maintainer="JFrog <partner-support@jfrog.com>"

## Fix the file permission of root on fluentd directory
USER root
## Env variables
ENV JF_PRODUCT_DATA_INTERNAL=JF_PRODUCT_DATA_INTERNAL_VALUE

## Copy fluentd.conf file
COPY FLUENT_CONF_FILE_NAME /opt/bitnami/fluentd/conf/fluentd.conf
## Create JF product folder (used to mount the host JF logs folder)
RUN mkdir -p "$JF_PRODUCT_DATA_INTERNAL"
RUN chown -R 1001:1001 /opt/bitnami/fluentd/
## Reset back to user
USER 1001