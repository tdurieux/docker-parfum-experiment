# LICENSE UPL 1.0
#
# Copyright (c) 2018, 2019 Oracle and/or its affiliates. All rights reserved.
#
# ORACLE DOCKERFILES PROJECT
# --------------------------
# This Dockerfile extends the Oracle WebLogic install image, upgrades OPatch, and applies necesary patch for
# the WebLogic Kubernetes Operator 2.0.  The patch 29135930 is applied on top of the Oct 2018 PSU and requires i
# an upgrade of OPatch to 13.9.4.0.

# REQUIRED FILES TO BUILD THIS IMAGE
# ----------------------------------
# (1) p28186730_139400_Generic.zip (Opatch update)
# (2) p28298734_122130_Generic.zip (WLS PATCH SET UPDATE 12.2.1.3.181016 )
# (3) p29135930_12213181016_Generic.zip (On top of WLS PATCH SET UPDATE 12.2.1.3.181016)
#     Download the patches from http://support.oracle.com
#
# HOW TO BUILD THIS IMAGE
# -----------------------
# Put all downloaded files in the same directory as this Dockerfile
# Run:
#      $ sudo docker build -t oracle/weblogic:12213-update-k8s Dockerfile.patch-ontop-12213-psu .
#

# Pull base image
# ---------------
# If pulling the WebLogic 12.2.1.3 image from the Docker Store please use:
# FROM store/oracle/weblogic:12.2.1.3-dev
# If pulling the WebLogic 12.2.1.3 image from the Oracle Container Registry please use:
# FROM container-registry.oracle.com/middleware/weblogic:12.2.1.3-dev
FROM oracle/weblogic:12.2.1.3-developer

# Maintainer
# ----------
MAINTAINER Monica Riccelli <monica.riccelli@oracle.com>

# Environment variables required for this build (do NOT change)
# -------------------------------------------------------------
ENV PATCH_PKG0="p28186730_139400_Generic.zip"
ENV PATCH_PKG1="p28298734_122130_Generic.zip"
ENV PATCH_PKG2="p29135930_12213181016_Generic.zip"

# Copy supplemental package and scripts
# --------------------------------
COPY --chown=oracle:oracle $PATCH_PKG0 $PATCH_PKG1 $PATCH_PKG2 /u01/

# Installation of Supplemental Quick Installer
# --------------------------------------------
USER root
RUN yum -y install psmisc && rm -rf /var/cache/yum
USER oracle
RUN cd /u01 && $JAVA_HOME/bin/jar xf /u01/$PATCH_PKG0 && \
    java -jar /u01/6880880/opatch_generic.jar -silent oracle_home=/u01/oracle -ignoreSysPrereqs && \
    echo "opatch updated" && sleep 5 && \
    cd /u01 && $JAVA_HOME/bin/jar xf /u01/$PATCH_PKG1 && \
    cd /u01/28298734 && $ORACLE_HOME/OPatch/opatch apply -silent && \
    cd /u01 && $JAVA_HOME/bin/jar xf /u01/$PATCH_PKG2 && \
    cd /u01/29135930 && $ORACLE_HOME/OPatch/opatch apply -silent && \
    $ORACLE_HOME/OPatch/opatch util cleanup -silent && \
    rm /u01/$PATCH_PKG0 && rm /u01/$PATCH_PKG1 && rm /u01/$PATCH_PKG2 && \
    rm -rf /u01/6880880 && rm -rf /u01/29135930 && rm -rf /u01/28298734 && \
    rm -rf /u01/oracle/cfgtoollogs/opatch/*

WORKDIR ${ORACLE_HOME}

CMD ["/u01/oracle/createAndStartEmptyDomain.sh"]
