# LICENSE UPL 1.0
#
# Copyright (c) 2018, 2021 Oracle and/or its affiliates.
#
# ORACLE DOCKERFILES PROJECT
# --------------------------
# This is the Dockerfile for Oracle Database 18c Express Edition
# 
# REQUIRED FILES TO BUILD THIS IMAGE
# ----------------------------------
# None
#
# HOW TO BUILD THIS IMAGE
# -----------------------
# Run: 
#      $ docker build -t oracle/database:18.4.0-xe -f Dockerfile.xe .
#
#
# Pull base image
# ---------------
FROM oraclelinux:7-slim

# Labels
# ------
LABEL "provider"="Oracle"                                               \
      "issues"="https://github.com/oracle/docker-images/issues"         \
      "volume.data"="/opt/oracle/oradata"                               \
      "volume.setup.location1"="/opt/oracle/scripts/setup"              \
      "volume.setup.location2"="/docker-entrypoint-initdb.d/setup"      \
      "volume.startup.location1"="/opt/oracle/scripts/startup"          \
      "volume.startup.location2"="/docker-entrypoint-initdb.d/startup"  \
      "port.listener"="1521"                                            \
      "port.oemexpress"="5500"                                          \
      "port.apex"="8080"

# Environment variables required for this build (do NOT change)
# -------------------------------------------------------------
ENV ORACLE_BASE=/opt/oracle \
    ORACLE_HOME=/opt/oracle/product/18c/dbhomeXE \
    ORACLE_SID=XE \
    INSTALL_FILE_1="https://download.oracle.com/otn-pub/otn_software/db-express/oracle-database-xe-18c-1.0-1.x86_64.rpm" \
    RUN_FILE="runOracle.sh" \
    PWD_FILE="setPassword.sh" \
    CONF_FILE="oracle-xe-18c.conf" \
    CHECK_SPACE_FILE="checkSpace.sh" \
    CHECK_DB_FILE="checkDBStatus.sh" \
    INSTALL_DIR="$HOME/install" \
    ORACLE_DOCKER_INSTALL="true"

# Use second ENV so that variable get substituted
ENV PATH=$ORACLE_HOME/bin:$PATH

# Copy binaries
# -------------