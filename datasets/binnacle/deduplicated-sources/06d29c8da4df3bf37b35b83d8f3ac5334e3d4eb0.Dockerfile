# LICENSE CDDL 1.0 + GPL 2.0
#
# ORACLE DOCKERFILES PROJECT
# --------------------------
# This is the Dockerfile for WebLogic 12.1.3 ZIP Distro
# 
# IMPORTANT
# ---------
# The resulting image of this Dockerfile DOES NOT contain a WLS Domain.
# For that, look into the folder 'samples' for an example on how
# to create a domain on a new inherited image.
#
# You can go into 'samples/12.1.3-generic-domain' after building the generic raw image
# and build that image, for example:
# 
#   $ cd samples/12c-generic-domain
#   $ sudo docker build -t mywls .
#
# REQUIRED FILES TO BUILD THIS IMAGE
# ----------------------------------
# (1) wls1213_dev.zip
#     Download the Developer ZIP installer from http://www.oracle.com/technetwork/middleware/weblogic/downloads/wls-for-dev-1703574.html 
#
# (2) jdk-7u75-linux-x64.rpm
#     Download from http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html
#
# HOW TO BUILD THIS IMAGE
# -----------------------
# Put all downloaded files in the same directory as this Dockerfile
# Run: 
#      $ sudo docker build -t oracle/weblogic:12.1.3 . 
#
# Pull base image
# ---------------
FROM oraclelinux:7

# Maintainer
# ----------
MAINTAINER Bruno Borges <bruno.borges@oracle.com>

# Environment variables required for this build (do NOT change)
# -------------------------------------------------------------
ENV JAVA_RPM jdk-7u75-linux-x64.rpm
ENV WLS_PKG wls1213_dev.zip
ENV JAVA_HOME /usr/java/default
ENV MW_HOME /u01/oracle/wls12130
ENV CONFIG_JVM_ARGS -Djava.security.egd=file:/dev/./urandom

# SETUP FILESYSTEM AND ORACLE USER
# ------------------------------------------------------------
RUN mkdir /u01 && chmod a+xr /u01 && \
    useradd -b /u01 -m -s /bin/bash oracle

# Copy packages
COPY $WLS_PKG /u01/
COPY $JAVA_RPM /u01/

# Install and configure Oracle JDK 8u25
# -------------------------------------
RUN rpm -i /u01/$JAVA_RPM && \ 
    rm /u01/$JAVA_RPM

# Adjust file permissions, go to /u01 as user 'oracle' to proceed with WLS installation
RUN chown oracle:oracle -R /u01

# Installation of Weblogic 
USER oracle
WORKDIR /u01/oracle/
RUN jar xf /u01/$WLS_PKG && \
    ln -s /u01/oracle/wls12130 /u01/oracle/weblogic 

WORKDIR /u01/oracle/weblogic
RUN sh configure.sh -silent && \
    find /u01/oracle/wls12130 -name "*.sh" -exec chmod a+x {} \; && \
    rm /u01/$WLS_PKG

WORKDIR /u01/oracle

ENV PATH $PATH:/u01/oracle/weblogic/oracle_common/common/bin

# Define default command to start bash. 
CMD ["bash"]
