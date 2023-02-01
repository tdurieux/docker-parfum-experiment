FROM registry.fedoraproject.org/f29/s2i-core:latest

# Apache HTTP Server image.
#
# Volumes:
#  * /var/www - Datastore for httpd
#  * /var/log/httpd - Storage for logs when $HTTPD_LOG_TO_VOLUME is set
# Environment:
#  * $HTTPD_LOG_TO_VOLUME (optional) - When set, httpd will log into /var/log/httpd

ENV HTTPD_VERSION=2.4 \
    NAME=httpd \
    ARCH=x86_64

ENV SUMMARY="Platform for running Apache httpd $HTTPD_VERSION or building httpd-based application" \
    DESCRIPTION="Apache httpd $HTTPD_VERSION available as container, is a powerful, efficient, \
and extensible web server. Apache supports a variety of features, many implemented as compiled modules \
which extend the core functionality. \
These can range from server-side programming language support to authentication schemes. \
Virtual hosting allows one Apache installation to serve many different Web sites."

LABEL summary="$SUMMARY" \
      description="$DESCRIPTION" \
      io.k8s.description="$SUMMARY" \
      io.k8s.display-name="Apache httpd $HTTPD_VERSION" \
      io.openshift.expose-services="8080:http,8443:https" \
      io.openshift.tags="builder,httpd,httpd24" \
      com.redhat.component="$NAME" \
      name="$FGC/$NAME" \
      version="$HTTPD_VERSION" \
      usage="s2i build https://github.com/sclorg/httpd-container.git --context-dir=examples/sample-test-app/ $FGC/$NAME sample-server" \
      maintainer="SoftwareCollections.org <sclorg@redhat.com>"

EXPOSE 8080
EXPOSE 8443

RUN dnf install -y yum-utils gettext hostname && \
    INSTALL_PKGS="nss_wrapper bind-utils httpd mod_ssl" && \
    dnf install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    dnf clean all

ENV HTTPD_CONTAINER_SCRIPTS_PATH=/usr/share/container-scripts/httpd/ \
    HTTPD_APP_ROOT=${APP_ROOT} \
    HTTPD_CONFIGURATION_PATH=${APP_ROOT}/etc/httpd.d \
    HTTPD_MAIN_CONF_PATH=/etc/httpd/conf \
    HTTPD_MAIN_CONF_MODULES_D_PATH=/etc/httpd/conf.modules.d \
    HTTPD_MAIN_CONF_D_PATH=/etc/httpd/conf.d \
    HTTPD_VAR_RUN=/var/run/httpd \
    HTTPD_DATA_PATH=/var/www \
    HTTPD_DATA_ORIG_PATH=/var/www \
    HTTPD_LOG_PATH=/var/log/httpd

COPY ./s2i/bin/ $STI_SCRIPTS_PATH
COPY ./root /

# Generate SSL certs and reset permissions of filesystem to default values
# Reset permissions of filesystem to default values
RUN /usr/libexec/httpd-ssl-gencerts && \
    /usr/libexec/httpd-prepare && rpm-file-permissions

USER 1001

# Not using VOLUME statement since it's not working in OpenShift Online:
# https://github.com/sclorg/httpd-container/issues/30
# VOLUME ["${HTTPD_DATA_PATH}"]
# VOLUME ["${HTTPD_LOG_PATH}"]

CMD ["/usr/bin/run-httpd"]
