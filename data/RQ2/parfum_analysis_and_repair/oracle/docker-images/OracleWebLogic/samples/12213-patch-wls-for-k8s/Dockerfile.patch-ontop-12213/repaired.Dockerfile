# LICENSE UPL 1.0
#
# Copyright (c) 2018, 2019 Oracle and/or its affiliates. All rights reserved.
#
# ORACLE DOCKERFILES PROJECT
# --------------------------
# This Dockerfile extends the Oracle WebLogic install image, and applies necesary 
# patch for the WebLogic Kubernetes Operator 2.0.  The patch 28076014 is applied on top 
# of WebLogic 12.2.1.3.

# REQUIRED FILES TO BUILD THIS IMAGE
# ----------------------------------
# (1) p27117282_122130_Generic.zip (This patch is needed only if the WebLogic binary image
#     is created manually from this Github project)
# (2) p29135930_122130_Generic.zip (On top of WebLogic Server 12.2.1.3)
#     Download the patches from http://support.oracle.com
#
# HOW TO BUILD THIS IMAGE
# -----------------------
# Put all downloaded files in the same directory as this Dockerfile
# Run:
#      $ sudo docker build -t oracle/weblogic:12213-update-k8s -f Dockerfile.patch-ontop-12213 .
#

# Pull base image
# ---------------
# If pulling the WebLogic 12.2.1.3 image from the Docker Store please use:
# FROM store/oracle/weblogic:12.2.1.3-dev
# If pulling the WebLogic 12.2.1.3 image from the Oracle Container Registry please use:
# FROM container-registry.oracle.com/middleware/weblogic:12.2.1.3-dev
FROM oracle/weblogic:12.2.1.3-generic

# Maintainer
# ----------
MAINTAINER Monica Riccelli <monica.riccelli@oracle.com>

# Environment variables required for this build.
# -------------------------------------------------------------
# NOTE: That patch (p27117282) is needed only if the WebLogic binary image
# is created manually from this Github project under `dockerfiles/12.2.1.3`.
# Comment out the ENV command if not needed.
ENV PATCH_PKG1="p27117282_122130_Generic.zip"
ENV PATCH_PKG2="p29135930_122130_Generic.zip"

# PATCH_PKG1 (27117282) is only needed if the WebLogic binary image
# is created manually from this Github project under dockerfiles/12.2.1.3.
# Otherwise uncomment the command to `Copy Patch 29135930` and comment the command 
# to `Copy both Patches 27117282 & 29135930`
# ------------------------------------------------------------------------
# Copy patch 29135930 
# --------------------------------
# COPY $PATCH_PKG2 /u01/
# --------------------------------
# Copy patches 27117282 & 29135930 
# --------------------------------
COPY --chown=oracle:oracle $PATCH_PKG1 $PATCH_PKG2 /u01/

# PATCH_PKG1 (27117282) is only needed if the WebLogic binary image
# is created manually from this Github project under dockerfiles/12.2.1.3.
# Otherwise uncomment the statements to `Apply Patch 29135930` and comment the commands 
# to `Apply Patches 27117282 & 29135930`
# --------------------------------------------
# Apply Patch 29135930
# --------------------------------------------
#USER oracle
#RUN cd /u01 && $JAVA_HOME/bin/jar xf /u01/$PATCH_PKG2 && \
#    cd /u01/29135930 && $ORACLE_HOME/OPatch/opatch apply -silent && \
#    $ORACLE_HOME/OPatch/opatch util cleanup -silent && \
#    rm /u01/$PATCH_PKG2 && \
#    rm -rf /u01/29135930 && \
#    rm -rf /u01/oracle/cfgtoollogs/opatch/* 
# --------------------------------------------
# Apply Patches 27117282 & 29135930
# --------------------------------------------