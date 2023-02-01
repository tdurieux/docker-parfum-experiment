# LICENSE UPL 1.0
#
# Copyright (c) 2018 Oracle and/or its affiliates. All rights reserved.
#
# ORACLE DOCKERFILES PROJECT
# --------------------------
# This Dockerfile extends the Oracle WebLogic install image, upgrades OPatch, and applies a patch.

# REQUIRED FILES TO BUILD THIS IMAGE
# ----------------------------------
# (1) p28186730_139400_Generic.zip"
# (2) p27117282_122130_Generic.zip
#     Download the patches from http://support.oracle.com
#
# HOW TO BUILD THIS IMAGE
# -----------------------
# Put all downloaded files in the same directory as this Dockerfile
# Run:
#      $ sudo docker build -t oracle/weblogic:12213-opatch-upgrade .
#

# Pull base image
# ---------------
FROM oracle/weblogic:12.2.1.3-developer

# Maintainer
# ----------
MAINTAINER Monica Riccelli <monica.riccelli@oracle.com>

# Environment variables required for this build (do NOT change)
# -------------------------------------------------------------
ENV PATCH_PKG0="p28186730_139400_Generic.zip"
ENV PATCH_PKG1="p27117282_122130_Generic.zip"

# Copy supplemental package and scripts
# --------------------------------
COPY $PATCH_PKG0 $PATCH_PKG1 /u01/

# Installation of Supplemental Quick Installer
# --------------------------------------------
USER root
RUN yum -y install psmisc
USER oracle
RUN cd /u01 && $JAVA_HOME/bin/jar xf /u01/$PATCH_PKG0 && \
    java -jar /u01/6880880/opatch_generic.jar -silent oracle_home=/u01/oracle -ignoreSysPrereqs && \
    echo "opatch updated" && sleep 5 && \
    cd /u01 && $JAVA_HOME/bin/jar xf /u01/$PATCH_PKG1 && \
    cd /u01/27117282 && $ORACLE_HOME/OPatch/opatch apply -silent && \
    $ORACLE_HOME/OPatch/opatch util cleanup -silent && \
    rm /u01/$PATCH_PKG0 && rm /u01/$PATCH_PKG1 && \
    rm -rf /u01/6880880 && rm -rf /u01/27117282 && \
    rm -rf /u01/oracle/cfgtoollogs/opatch/* 

WORKDIR ${ORACLE_HOME}

CMD ["/u01/oracle/createAndStartEmptyDomain.sh"]
