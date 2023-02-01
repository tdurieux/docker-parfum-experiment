## EXCLUDE BEGIN ##
## extract the tarball
#@follow_tag(registry.redhat.io/ubi8:latest)
FROM registry.redhat.io/ubi8:8.5-236.1647448331 AS builder

ARG upstream_code=upstream_code
ARG upstream_tarball=${upstream_code}.tar.gz

COPY ${CI_ARCHIVE_ORIGIN_AGGREGATED_LOGGING} ${upstream_tarball}
RUN mkdir -p ${upstream_code} \
    && tar -xzf ${upstream_tarball} \
        --strip-components 1 \
        -C ${upstream_code} && rm ${upstream_tarball}
## EXCLUDE END ##

## EXCLUDE BEGIN ##
#@follow_tag(registry.redhat.io/ubi8:latest)
## EXCLUDE END ##
FROM registry.redhat.io/ubi8:8.5

ENV HOME=/opt/app-root/src

ENV NODEJS_VERSION=10 \
    NPM_RUN=start \
    NAME=nodejs \
    NPM_CONFIG_PREFIX=$HOME/.npm-global \
    PATH=$HOME/node_modules/.bin/:$HOME/.npm-global/bin/:$PATH

USER 0

WORKDIR ${HOME}

RUN yum -y module enable nodejs:$NODEJS_VERSION && \
    INSTALL_PKGS="nodejs npm nodejs-nodemon nss_wrapper" && \
    ln -s /usr/lib/node_modules/nodemon/bin/nodemon.js /usr/bin/nodemon && \
    ln -s /usr/libexec/platform-python /usr/bin/python3 && \
    yum remove -y $INSTALL_PKGS && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum -y clean all --enablerepo='*' && rm -rf /var/cache/yum

## EXCLUDE BEGIN ##
ARG upstream_code=upstream_code/kibana
## EXCLUDE END ##
ENV BUILD_VERSION=6.8.1
ENV SOURCE_GIT_COMMIT=${CI_ORIGIN_AGGREGATED_LOGGING_UPSTREAM_COMMIT:-}
ENV SOURCE_GIT_URL=${CI_ORIGIN_AGGREGATED_LOGGING_UPSTREAM_URL:-}

MAINTAINER OpenShift Development <dev@lists.openshift.redhat.com>

EXPOSE 5601

ENV ELASTICSEARCH_URL=https://elasticsearch.openshift-logging.svc.cluster.local:9200 \
    KIBANA_CONF_DIR=${HOME}/config \
    KIBANA_VERSION=6.8.1 \
    NODE_ENV=production \
    RELEASE_STREAM=prod \
    container=oci \
    NODE_ENV=production \
    NODE_PATH=/usr/bin

ARG LOCAL_REPO

## EXCLUDE BEGIN ##
ENV upstream_code=upstream_code/kibana
## EXCLUDE END ##
ENV upstream_code=${upstream_code:-"."}
COPY --from=builder ${upstream_code}/vendored_tar_src/kibana-oss-6.8.1 ${HOME}/
COPY --from=builder ${upstream_code}/vendored_tar_src/opendistro_security_kibana_plugin-0.10.0.4/ ${HOME}/plugins/opendistro_security_kibana_plugin-0.10.0.4/
COPY --from=builder ${upstream_code}/vendored_tar_src/handlebars/ ${HOME}/node_modules/handlebars/
COPY --from=builder ${upstream_code}/vendored_tar_src/minimist/ ${HOME}/node_modules/minimist/
COPY --from=builder ${upstream_code}/vendored_tar_src/ua-parser-js-1.0.2/ ${HOME}/node_modules/ua-parser-js/
COPY --from=builder ${upstream_code}/vendored_tar_src/fbjs-0.8.18/ ${HOME}/node_modules/fbjs/

RUN chmod -R og+w ${HOME}/
COPY --from=builder ${upstream_code}/probe/ /usr/share/kibana/probe/
COPY --from=builder ${upstream_code}/kibana.yml ${KIBANA_CONF_DIR}/
COPY --from=builder ${upstream_code}/run.sh ${HOME}/
COPY --from=builder ${upstream_code}/utils ${HOME}/
COPY --from=builder ${upstream_code}/module_list.sh ${HOME}/
RUN sed -i -e 's/"node":.*/"node": "'$(${NODE_PATH}/node --version | sed 's/v//')'"/' package.json && \
    mkdir -p node && \
    ln -s ${NODE_PATH} node/bin
RUN bin/kibana --optimize

WORKDIR ${HOME}
CMD ["./run.sh"]

LABEL \
        License="Apache-2.0" \
        io.k8s.description="Kibana container for querying Elasticsearch for aggregated logs" \
        io.k8s.display-name="Kibana" \
        io.openshift.tags="logging,elk,kibana" \
        vendor="Red Hat" \
        name="openshift-logging/kibana6-rhel8" \
        com.redhat.component="logging-kibana6-container" \
        io.openshift.maintainer.product="OpenShift Container Platform" \
        io.openshift.build.commit.id=${CI_ORIGIN_AGGREGATED_LOGGING_UPSTREAM_COMMIT} \
        io.openshift.build.source-location=${CI_ORIGIN_AGGREGATED_LOGGING_UPSTREAM_URL} \
        io.openshift.build.commit.url=${CI_ORIGIN_AGGREGATED_LOGGING_UPSTREAM_URL}/commit/${CI_ORIGIN_AGGREGATED_LOGGING_UPSTREAM_COMMIT} \
        version=v6.8.1
