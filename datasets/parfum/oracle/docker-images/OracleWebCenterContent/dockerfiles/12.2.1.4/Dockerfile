# Copyright (c) 2021, Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl
# 
# ORACLE DOCKERFILES PROJECT
# --------------------------
# This is the Dockerfile for Oracle WebCenter Content 12.2.1.4.0
#
# Base image of this dockerfile is Oracle Fusion Middleware Infrastructure 12.2.1.4.0 docker image.
# Pull base image from the Oracle Container Registry or Docker Store and tag the name as 'oracle/fmw-infrastructure:12.2.1.4.0'
# 
# REQUIRED FILES TO BUILD THIS IMAGE
# ----------------------------------
# (1) fmw_12.2.1.4.0_wccontent_generic.jar
#
# Download required binaries from Oracle Software Delivery Cloud
# 
# HOW TO BUILD THIS IMAGE
# -----------------------
# Put downloaded binary in the same directory as this Dockerfile
# Run:
#      $ docker build -t oracle/wccontent:12.2.1.4.0 .
# 
#

# ------------------------------------------------------------
FROM oracle/fmw-infrastructure:12.2.1.4.0 as builder

LABEL "provider"="Oracle"                     \
      "maintainer"="WBECENTER CONTENT DEV"    \
      "issues"="https://github.com/oracle/docker-images/issues"

# -------------------------------------------------------------
# Environment variables required for this build (do NOT change)
# -------------------------------------------------------------
USER root

ENV CONTENT_JAR=fmw_12.2.1.4.0_wccontent.jar \
    ORACLE_HOME=/u01/oracle \
    VOLUME_DIR=/u01/oracle/user_projects \
    SCRIPT_FILE=/u01/oracle/container-scripts/* \
    USER_MEM_ARGS="-Djava.security.egd=file:/dev/./urandom" \
    PATH=$PATH:$JAVA_HOME/bin:$ORACLE_HOME/oracle_common/common/bin:/u01/oracle/wlserver/common/bin:/u01/oracle/container-scripts
    
# -------------------------------------------------------------
# Install packages and adjust file permissions
# -------------------------------------------------------------
RUN mkdir -p /u01 && \
    yum install -y hostname && \
    rm -rf /var/cache/yum && \
    mkdir -p $VOLUME_DIR && \
    mkdir -p /u01/oracle/container-scripts && \
    mkdir -p /u01/oracle/silent-install-files-tmp/config && \
    mkdir -p /u01/oracle/logs && \
    chmod a+xr /u01

# -------------------------------------------------------------
# Copy packages and scripts 
# -------------------------------------------------------------
COPY $CONTENT_JAR install.file oraInst.loc /u01/
COPY container-scripts/*.* /u01/oracle/container-scripts/

# -------------------------------------------------------------
# Adjust file permissions, go to /u01 as user 'oracle' to proceed with WLS installation
# -------------------------------------------------------------
RUN chown oracle:root -R /u01 $VOLUME_DIR && \
    chmod a+xr /u01/oracle/*.* && \
    chmod a+xr /u01/oracle/container-scripts/*.*

# -------------------------------------------------------------
# Install Oracle Fusion Middleware Infrastructure
# Install Webcenter Content
# as user oracle 
# -------------------------------------------------------------
USER oracle

RUN $JAVA_HOME/bin/java -jar /u01/$CONTENT_JAR -silent -responseFile /u01/install.file -invPtrLoc /u01/oraInst.loc -jreLoc $JAVA_HOME -ignoreSysPrereqs -force -novalidation ORACLE_HOME=$ORACLE_HOME INSTALL_TYPE="WebCenter Content" && \
rm /u01/$CONTENT_JAR /u01/oraInst.loc /u01/install.file

#Rebuilding Base image
FROM oracle/fmw-infrastructure:12.2.1.4.0

USER root

ENV PATH=$PATH:$JAVA_HOME/bin:$ORACLE_HOME/oracle_common/common/bin:/u01/oracle/wlserver/common/bin:/u01/oracle/container-scripts

COPY --from=builder --chown=oracle:root /u01 /u01

# -------------------------------------------------------------
# Expose all Ports
# -------------------------------------------------------------
EXPOSE $UCM_PORT $UCM_INTRADOC_PORT $IBR_INTRADOC_PORT $IBR_PORT $ADMIN_PORT $IPM_PORT $WCCADF_PORT $CAPTURE_PORT

USER oracle

# -------------------------------------------------------------
# Define work directory
# -------------------------------------------------------------
WORKDIR ${ORACLE_HOME}

# -------------------------------------------------------------
# Define default command to start bash
# -------------------------------------------------------------
CMD ["/u01/oracle/container-scripts/createDomainandStartAdmin.sh"]
