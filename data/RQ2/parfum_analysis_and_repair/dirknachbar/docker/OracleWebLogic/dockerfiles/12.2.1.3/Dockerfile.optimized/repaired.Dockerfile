#Copyright (c) 2014-2018 Oracle and/or its affiliates. All rights reserved.
#
#Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
#
# ORACLE DOCKERFILES PROJECT
# --------------------------
# This is the Dockerfile for Oracle WebLogic Server 12.2.1.3 Generic Distro
#
# REQUIRED FILES TO BUILD THIS IMAGE
# ----------------------------------
# (1) fmw_12.2.1.3.0_wls_Disk1_1of1.zip
#     Download the Generic installer from http://www.oracle.com/technetwork/middleware/weblogic/downloads/wls-for-dev-1703574.html
#
# (2) server-jre-8uXX-linux-x64.tar.gz
#     Download from http://www.oracle.com/technetwork/java/javase/downloads/server-jre8-downloads-2133154.html
#
# HOW TO BUILD THIS IMAGE
# -----------------------
# Put all downloaded files in the same directory as this Dockerfile
# Run:
#      $ docker build -f Dockerfile.generic -t oracle/weblogic:12.2.1.3-generic .
#
# IMPORTANT
# ---------
# The resulting image of this Dockerfile contains a WLS Empty Domain.
#
# Pull base image
# From the Oracle Registry
# -------------------------
FROM oracle/serverjre:8 as base

# Maintainer
# ----------
LABEL maintainer="dirk.nachbar@trivadis.com"

# Common environment variables required for this build (do NOT change)
# --------------------------------------------------------------------
ENV ORACLE_HOME=/u01/oracle \
    USER_MEM_ARGS="-Djava.security.egd=file:/dev/./urandom" \
    SCRIPT_FILE=/u01/oracle/createAndStartEmptyDomain.sh \
    PATH=$PATH:${JAVA_HOME}/bin:/u01/oracle/oracle_common/common/bin:/u01/oracle/wlserver/common/bin

# Setup filesystem and oracle user
# Adjust file permissions, go to /u01 as user 'oracle' to proceed with WLS installation
# ------------------------------------------------------------
RUN mkdir -p /u01 && \
    chmod a+xr /u01 && \
    useradd -b /u01 -d /u01/oracle -m -s /bin/bash oracle

# Copy scripts
#-------------
COPY container-scripts/createAndStartEmptyDomain.sh container-scripts/create-wls-domain.py /u01/oracle/

# Domain and Server environment variables
# ------------------------------------------------------------
ENV DOMAIN_NAME="${DOMAIN_NAME:-base_domain}" \
    ADMIN_LISTEN_PORT="${ADMIN_LISTEN_PORT:-7001}" \
    ADMIN_NAME="${ADMIN_NAME:-AdminServer}" \
    ADMINISTRATION_PORT_ENABLED="${ADMINISTRATION_PORT_ENABLED:-true}" \
    ADMINISTRATION_PORT="${ADMINISTRATION_PORT:-9002}"

# Environment variables required for this build (do NOT change)
# -------------------------------------------------------------
ENV FMW_PKG=fmw_12.2.1.3.0_wls_Disk1_1of1.zip \
    FMW_JAR=fmw_12.2.1.3.0_wls.jar

FROM base as builder

# Copy packages
# -------------
COPY $FMW_PKG install.file oraInst.loc /u01/
RUN  chown oracle:oracle -R /u01 && \
     chmod +xr $SCRIPT_FILE

# Install
# ------------------------------------------------------------
USER oracle

RUN cd /u01 && ${JAVA_HOME}/bin/jar xf /u01/$FMW_PKG && cd - && \
    ls /u01 && \
    ${JAVA_HOME}/bin/java -jar /u01/$FMW_JAR -silent -responseFile /u01/install.file -invPtrLoc /u01/oraInst.loc -jreLoc $JAVA_HOME -ignoreSysPrereqs -force -novalidation ORACLE_HOME=$ORACLE_HOME INSTALL_TYPE="WebLogic Server" && \
    rm /u01/$FMW_JAR /u01/$FMW_PKG /u01/oraInst.loc /u01/install.file

FROM base 

COPY --chown=oracle:oracle --from=builder $ORACLE_HOME $ORACLE_HOME
COPY --chown=oracle:oracle --from=builder $JAVA_HOME $JAVA_HOME

WORKDIR ${ORACLE_HOME}

# Define default command to start script.