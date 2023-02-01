# Dockerfile for bitnami/fluentd sidecar image with all the necessary plugins for our log analytic providers
FROM bitnami/fluentd:latest
LABEL maintainer "Partner Engineering <partner_support@jfrog.com>"

USER root

##Uninstall elastic plugin which is preinstalled in bitnami fluentd
##Pin elastic gem version to 7.14
RUN fluent-gem uninstall elasticsearch -a --ignore-dependencies
RUN fluent-gem install elasticsearch -v 7.14 --no-document
## Install custom Fluentd plugins