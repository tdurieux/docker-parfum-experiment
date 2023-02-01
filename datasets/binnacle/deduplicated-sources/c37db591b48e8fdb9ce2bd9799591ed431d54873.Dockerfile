# LICENSE UPL 1.0
#
# Copyright (c) 2014-2018 Oracle and/or its affiliates. All rights reserved.
#
# ORACLE DOCKERFILES PROJECT
# --------------------------
# This is the Dockerfile for WebLogic 12.2.1 Quick Install Distro
#
# REQUIRED FILES TO BUILD THIS IMAGE
# ----------------------------------
# (1) fmw_12.2.1.0.0_wls_quick_Disk1_1of1.zip
#     Download the Developer Quick installer from http://www.oracle.com/technetwork/middleware/weblogic/downloads/wls-for-dev-1703574.html
#
# (2) server-jre-8uXX-linux-x64.tar.gz
#     Download from http://www.oracle.com/technetwork/java/javase/downloads/server-jre8-downloads-2133154.html
#
# HOW TO BUILD THIS IMAGE
# -----------------------
# Put all downloaded files in the same directory as this Dockerfile
# Run:
#      $ docker build -t oracle/weblogic:12.2.1-developer .
#
# IMPORTANT
# ---------
# The resulting image of this Dockerfile DOES NOT contain a WLS Domain.
# For that, look into the folder 'samples' for an example on how
# to create a domain on a new inherited image.
#
# You can go into 'samples/1221-domain' after building the developer install image
# and build the domain image, for example:
#
#   $ cd samples/1221-domain
#   $ docker build -t mywls .
#
# Pull base image
# ---------------
FROM oracle/serverjre:8

# Maintainer
# ----------
MAINTAINER Bruno Borges <bruno.borges@oracle.com>

#Common ENV
#-----------
ENV ORACLE_HOME=/u01/oracle \
    USER_MEM_ARGS="-Djava.security.egd=file:/dev/./urandom" \
    PATH=$PATH:/usr/java/default/bin:/u01/oracle/oracle_common/common/bin

# Setup filesystem and oracle user
# Adjust file permissions, go to /u01 as user 'oracle' to proceed with WLS installation
# ------------------------------------------------------------
RUN mkdir -p /u01 && \
    chmod a+xr /u01 && \
    useradd -b /u01 -d /u01/oracle -m -s /bin/bash oracle

# Environment variables required for this build (do NOT change)
# -------------------------------------------------------------
ENV FMW_PKG=fmw_12.2.1.0.0_wls_quick_Disk1_1of1.zip \
    FMW_JAR=fmw_12.2.1.0.0_wls_quick.jar \
    DEBUG_FLAG=true\
    PRODUCTION_MODE=dev

# Copy packages
# -------------
COPY $FMW_PKG install.file oraInst.loc /u01/
RUN chown oracle:oracle -R /u01


# Install
#-------------------------------------------------------------
USER oracle
RUN cd /u01 && $JAVA_HOME/bin/jar xf /u01/$FMW_PKG && cd - && \
    $JAVA_HOME/bin/java -jar /u01/$FMW_JAR -invPtrLoc /u01/oraInst.loc -jreLoc $JAVA_HOME -ignoreSysPrereqs -force -novalidation ORACLE_HOME=$ORACLE_HOME && \
    rm /u01/$FMW_JAR /u01/$FMW_PKG /u01/oraInst.loc /u01/install.file

WORKDIR $ORACLE_HOME

# Define default command to start bash.
CMD ["bash"]
