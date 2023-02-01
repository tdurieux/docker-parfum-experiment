FROM bitnami/python:3.7.3-debian-9-r72 as development

######

FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates libbz2-1.0 libc6 libffi6 libncurses5 libreadline7 libsqlite3-0 libssl1.1 libtinfo5 zlib1g
RUN sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS    90/' /etc/login.defs && \
    sed -i 's/^PASS_MIN_DAYS.*/PASS_MIN_DAYS    0/' /etc/login.defs && \
    sed -i 's/sha512/sha512 minlen=8/' /etc/pam.d/common-password

COPY --from=development /opt/bitnami/python /opt/bitnami/python

ENV BITNAMI_APP_NAME="python" \
    BITNAMI_IMAGE_VERSION="3.7.3-debian-9-r72-prod" \
    PATH="/opt/bitnami/python/bin:$PATH"

CMD [ "python" ]
