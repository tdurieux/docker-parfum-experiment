ARG BASE_IMAGE
FROM ${BASE_IMAGE}

# useradd, groupmod
RUN yum install -y shadow-utils && rm -rf /var/cache/yum
ENV GOSU_VERSION 1.14
# https://github.com/tianon/gosu/releases/tag/1.14
# key https://keys.openpgp.org/search?q=tianon%40debian.org
RUN curl -f -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64" \
    && chmod +x /usr/local/bin/gosu
RUN mkdir -p /sebs/
COPY docker/nodejs_installer.sh /sebs/installer.sh
COPY docker/entrypoint.sh /sebs/entrypoint.sh
RUN chmod +x /sebs/entrypoint.sh

# useradd and groupmod is installed in /usr/sbin which is not in PATH
ENV PATH=/usr/sbin:$PATH
ENV SCRIPT_FILE=/mnt/function/package.sh
CMD /bin/bash /sebs/installer.sh
ENTRYPOINT ["/sebs/entrypoint.sh"]
