FROM bitnami/ruby:2.5.5-ol-7-r94 as development

######

FROM bitnami/oraclelinux-runtimes:7-r349
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates glibc keyutils-libs krb5-libs libcom_err libselinux ncurses-libs nss-softokn-freebl openssl-libs pcre readline wget zlib

COPY --from=development /opt/bitnami/ruby /opt/bitnami/ruby

ENV BITNAMI_APP_NAME="ruby" \
    BITNAMI_IMAGE_VERSION="2.5.5-ol-7-r93-prod" \
    PATH="/opt/bitnami/ruby/bin:$PATH"

CMD [ "irb" ]
