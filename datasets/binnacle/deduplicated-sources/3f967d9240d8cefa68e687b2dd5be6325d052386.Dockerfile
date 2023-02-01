# LICENSE CDDL 1.0 + GPL 2.0
#
# Adapted from ORACLE DOCKERFILES PROJECT
# --------------------------
# This Dockerfile extends the Oracle WebLogic image by creating a sample domain.
#
# Util scripts are copied into the image enabling users to plug NodeManager 
# automatically into the AdminServer running on another container.
#
#
# ENVIRONMENT VARIABLES:
# ----------------------
#
# ADMIN_PASSWORD  - Default random
#
# ADMIN_PORT      - Default 8001
#
# CLUSTER_NAME    - Default DockerCluster
#
# DEBUG_FLAG      - Default false
#
# PRODUCTION_MODE - Default prod
#
#
FROM rhel7-weblogic
MAINTAINER Johnathan Kupferer <jkupfere@redhat.com>

# WLS Configuration (editable during runtime)
# ---------------------------
ENV ADMIN_HOST="wlsadmin" \
    NM_PORT="5556" \
    MS_PORT="7001" \
    DEBUG_PORT="8453" \
    CONFIG_JVM_ARGS="-Dweblogic.security.SSL.ignoreHostnameVerification=true"

# WLS Configuration (persisted. do not change during runtime)
# -----------------------------------------------------------
ENV DOMAIN_NAME="${DOMAIN_NAME:-base_domain}" \
    DOMAIN_HOME=/u01/oracle/user_projects/domains/${DOMAIN_NAME:-base_domain} \
    ADMIN_PORT="${ADMIN_PORT:-8001}" \
    CLUSTER_NAME="${CLUSTER_NAME:-DockerCluster}" \
    debugFlag="${DEBUG_FLAG:-false}" \
    PRODUCTION_MODE="${PRODUCTION_MODE:-prod}" \
    PATH=$PATH:/u01/oracle/oracle_common/common/bin:/u01/oracle/wlserver/common/bin:/u01/oracle/user_projects/domains/${DOMAIN_NAME:-base_domain}/bin:/u01/oracle

# Add files required to build this image
USER oracle
COPY container-scripts/* /u01/oracle/

# Configuration of WLS Domain
RUN export ADMIN_PASSWORD=$(if [ -z "$ADMIN_PASSWORD" ]; then dd if=/dev/urandom bs=15 count=1 2>/dev/null | base64 -w 0; else echo "$ADMIN_PASSWORD"; fi) && \
    /u01/oracle/wlst /u01/oracle/create-wls-domain.py && \
    echo password= >> /u01/oracle/user_projects/domains/$DOMAIN_NAME/servers/AdminServer/security/boot.properties && \
    mkdir -p /u01/oracle/user_projects/domains/$DOMAIN_NAME/servers/AdminServer/security && \
    echo "username=weblogic" > /u01/oracle/user_projects/domains/$DOMAIN_NAME/servers/AdminServer/security/boot.properties && \ 
    echo "password=$ADMIN_PASSWORD" >> /u01/oracle/user_projects/domains/$DOMAIN_NAME/servers/AdminServer/security/boot.properties && \
    echo ". /u01/oracle/user_projects/domains/$DOMAIN_NAME/bin/setDomainEnv.sh" >> /u01/oracle/.bashrc && \
    find /u01 -user oracle -exec chmod a+rwX /u01 {} ';'

# Expose Node Manager default port, and also default for admin and managed server 
# oc new-app does not like variables used in ports.
#EXPOSE $NM_PORT $ADMIN_PORT $MS_PORT $DEBUG_PORT
EXPOSE 5556 8001 7001 8453

WORKDIR $DOMAIN_HOME

# Define default command to start bash. 
CMD ["startWebLogic.sh"]
