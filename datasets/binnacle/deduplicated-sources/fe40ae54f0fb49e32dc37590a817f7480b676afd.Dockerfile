ARG FROM_IMAGE
FROM ${FROM_IMAGE}

ARG HIVE_PACKAGE='hive'

RUN \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install krb5-kdc krb5-admin-server -y && \
    update-rc.d krb5-kdc enable

ARG PATH_PREFIX
COPY ${PATH_PREFIX}/../common/kerberos/krb5.conf /etc/krb5.conf
COPY ${PATH_PREFIX}/../common/conf-kerberos/ ${HADOOP_CONF_DIR}
COPY ${PATH_PREFIX}/../common/kerberos/00_kerberos_init /etc/startup/
COPY ${PATH_PREFIX}/../common/conf-hive-kerberos/hive-site.xml /etc/${HIVE_PACKAGE}/conf/

RUN \
    chmod +x /usr/sbin/krb-init-kadmin.sh && \
    chmod +x /usr/sbin/krb-edit-hadoop-confs.sh && \
    sync && \
    /usr/sbin/krb-init-kadmin.sh yarn:hadoop && \
    /usr/sbin/krb-edit-hadoop-confs.sh && \
    chmod 644 ${HADOOP_CONF_DIR}/container-executor.cfg

ENV KRB_ENABLED=true
