# LICENSE UPL 1.0
#
# Copyright (c) 2014-2018 Oracle and/or its affiliates. All rights reserved.
#
# ORACLE DOCKERFILES PROJECT
# --------------------------
# This is the Dockerfile for WebLogic 12.1.3 ZIP Distro
#
# REQUIRED FILES TO BUILD THIS IMAGE
# ----------------------------------
# (1) wls1213_dev_update3.zip
#     Download the Developer ZIP Update 3 installer from http://www.oracle.com/technetwork/middleware/weblogic/downloads/wls-for-dev-1703574.html
#
# (2) server-jre-8uXX-linux-x64.tar.gz
#     Download from http://www.oracle.com/technetwork/java/javase/downloads/server-jre8-downloads-2133154.html
#
# HOW TO BUILD THIS IMAGE
# -----------------------
# Put all downloaded files in the same directory as this Dockerfile
# Run:
#      $ docker build -t oracle/weblogic:12.1.3-developer .
#
# IMPORTANT
# ---------
# The resulting image of this Dockerfile DOES NOT contain a WLS Domain.
# For that, look into the folder 'samples' for an example on how
# to create a domain on a new inherited image.
#
# You can go into 'samples/1213-domain' after building the developer install image
# and build the domain image, for example:
#
#   $ cd samples/1213-domain
#   $ docker build -t mywls .
#
# Pull base image
# ---------------
FROM oracle/serverjre:8

# Maintainer
# ----------
MAINTAINER Bruno Borges <bruno.borges@oracle.com>

# Environment variables required for this build
# ---------------------------------------------
ENV ORACLE_HOME=/u01/oracle \
    USER_MEM_ARGS="-Djava.security.egd=file:/dev/./urandom" \
    PATH=$PATH:/usr/java/default/bin:/u01/oracle/oracle_common/common/bin

# Setup required packages, filesystem, and oracle user.
# Install and configure Oracle JDK
# Adjust file permissions, go to /u01 as user 'oracle' to proceed with WLS installation
# ------------------------------------------------------------
RUN mkdir -p /u01 && \
    chmod a+xr /u01 && \
    useradd -b /u01 -d /u01/oracle -m -s /bin/bash oracle

# Environment variables required for this build (do NOT change)
# -------------------------------------------------------------
ENV FMW_PKG=wls1213_dev_update3.zip \
    MW_HOME=/u01/oracle

# Copy packages
# -------------
COPY $FMW_PKG /u01/
RUN  chown oracle:oracle -R /u01


# Setup filesystem and oracle user
# Install and configure Oracle JDK
# Adjust file permissions, go to /u01 as user 'oracle' to proceed with WLS installation
# ------------------------------------------------------------
RUN $JAVA_HOME/bin/jar xf /u01/$FMW_PKG && \
    mv wls12130/* $ORACLE_HOME && rmdir wls12130 && \
    cd $ORACLE_HOME && \
    sh configure.sh -silent && \
    find $ORACLE_HOME -name "*.sh" -exec chmod a+x {} \; && \
    rm /u01/$FMW_PKG

WORKDIR $ORACLE_HOME
USER oracle

# Define default command to start bash.
CMD ["bash"]
