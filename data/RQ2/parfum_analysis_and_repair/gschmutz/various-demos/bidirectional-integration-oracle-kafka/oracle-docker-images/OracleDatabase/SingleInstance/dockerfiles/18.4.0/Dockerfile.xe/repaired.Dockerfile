# LICENSE UPL 1.0
#
# Copyright (c) 1982-2018 Oracle and/or its affiliates. All rights reserved.
#
# ORACLE DOCKERFILES PROJECT
# --------------------------
# This is the Dockerfile for Oracle Database 18c Express Edition
# 
# REQUIRED FILES TO BUILD THIS IMAGE
# ----------------------------------
# (1) oracle-database-xe-18c-1.0-1.x86_64.rpm
#     Download Oracle Database Express Edition (XE) Release 18.4.0.0.0 (18c) for Linux x64
#     from https://www.oracle.com/technetwork/database/database-technologies/express-edition/downloads/index.html
#
# HOW TO BUILD THIS IMAGE
# -----------------------
# Put the downloaded file in the same directory as this Dockerfile
# Run: 
#      $ docker build -t oracle/database:18.4.0-xe -f Dockerfile.xe .
#
#
# Pull base image
# ---------------
FROM oraclelinux:7-slim

# Maintainer
# ----------
MAINTAINER Gerald Venzl <gerald.venzl@oracle.com>

# Environment variables required for this build (do NOT change)
# -------------------------------------------------------------
ENV ORACLE_BASE=/opt/oracle \
    ORACLE_HOME=/opt/oracle/product/18c/dbhomeXE \
    ORACLE_SID=XE \
    INSTALL_FILE_1="oracle-database-xe-18c-1.0-1.x86_64.rpm" \
    RUN_FILE="runOracle.sh" \
    PWD_FILE="setPassword.sh" \
    CONF_FILE="oracle-xe-18c.conf" \
    CHECK_DB_FILE="checkDBStatus.sh" \
    INSTALL_DIR="$HOME/install" \
    ORACLE_DOCKER_INSTALL="true"

# Use second ENV so that variable get substituted
ENV PATH=$ORACLE_HOME/bin:$PATH

# Copy binaries
# -------------