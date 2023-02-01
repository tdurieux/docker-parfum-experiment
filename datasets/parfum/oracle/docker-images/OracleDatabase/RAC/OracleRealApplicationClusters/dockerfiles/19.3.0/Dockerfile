# LICENSE UPL 1.0
#
# Copyright (c) 1982-2018 Oracle and/or its affiliates. All rights reserved.
#
# ORACLE DOCKERFILES PROJECT
# --------------------------
# This is the Dockerfile for Oracle Database 19c Release 3 Real Application Clusters
# 
# REQUIRED FILES TO BUILD THIS IMAGE
# ----------------------------------
# (1) LINUX.X64_180000_db_home.zip
# (2) LINUX.X64_180000_grid_home.zip 
#     Download Oracle Grid 19c Release 3 Enterprise Edition for Linux x64
#     Download Oracle Database 19c Release 3  Enterprise Edition for Linux x64
#     from http://www.oracle.com/technetwork/database/enterprise-edition/downloads/index.html
#
# HOW TO BUILD THIS IMAGE
# -----------------------
# Run: 
#      $ docker build -t oracle/database:19.3.0-rac . 
#
# Pull base image
# ---------------
FROM oraclelinux:7-slim

# Maintainer
# ----------
MAINTAINER Paramdeep Saini <paramdeep.saini@oracle.com>

# Environment variables required for this build (do NOT change)
# -------------------------------------------------------------
# Linux Env Variable
ENV SETUP_LINUX_FILE="setupLinuxEnv.sh" \
    INSTALL_DIR=/opt/scripts \
# Grid Env variables
    GRID_BASE=/u01/app/grid \
    GRID_HOME=/u01/app/19.3.0/grid \
    INSTALL_FILE_1="LINUX.X64_193000_grid_home.zip" \
    GRID_INSTALL_RSP="gridsetup_19c.rsp" \
    GRID_SW_INSTALL_RSP="grid_sw_install_19c.rsp" \
    GRID_SETUP_FILE="setupGrid.sh" \
    FIXUP_PREQ_FILE="fixupPreq.sh" \
    INSTALL_GRID_BINARIES_FILE="installGridBinaries.sh" \
    INSTALL_GRID_PATCH="applyGridPatch.sh" \
    INVENTORY=/u01/app/oraInventory \
    CONFIGGRID="configGrid.sh"  \
    ADDNODE="AddNode.sh"   \
    DELNODE="DelNode.sh" \
    ADDNODE_RSP="grid_addnode.rsp"  \
    SETUPSSH="setupSSH.expect"  \
    DOCKERORACLEINIT="dockeroracleinit" \
    GRID_USER_HOME="/home/grid" \
    SETUPGRIDENV="setupGridEnv.sh" \
    ASM_DISCOVERY_DIR="/dev" \
    RESET_OS_PASSWORD="resetOSPassword.sh" \
    MULTI_NODE_INSTALL="MultiNodeInstall.py" \
# RAC DB Env Variables
    DB_BASE=/u01/app/oracle \
    DB_HOME=/u01/app/oracle/product/19.3.0/dbhome_1 \
    INSTALL_FILE_2="LINUX.X64_193000_db_home.zip" \
    DB_INSTALL_RSP="db_sw_install_19c.rsp" \
    DBCA_RSP="dbca_19c.rsp" \
    DB_SETUP_FILE="setupDB.sh" \
    PWD_FILE="setPassword.sh" \
    RUN_FILE="runOracle.sh" \
    STOP_FILE="stopOracle.sh" \
    ENABLE_RAC_FILE="enableRAC.sh" \
    CHECK_DB_FILE="checkDBStatus.sh" \
    USER_SCRIPTS_FILE="runUserScripts.sh" \
    REMOTE_LISTENER_FILE="remoteListener.sh" \ 
    INSTALL_DB_BINARIES_FILE="installDBBinaries.sh" \
    GRID_HOME_CLEANUP="GridHomeCleanup.sh" \
    ORACLE_HOME_CLEANUP="OracleHomeCleanup.sh" \
    DB_USER="oracle" \
    GRID_USER="grid" \
# COMMON ENV Variable
   FUNCTIONS="functions.sh" \
   COMMON_SCRIPTS="/common_scripts" \
   CHECK_SPACE_FILE="checkSpace.sh" \
   RESET_FAILED_UNITS="resetFailedUnits.sh" \
   SET_CRONTAB="setCrontab.sh" \
   CRONTAB_ENTRY="crontabEntry" \
   EXPECT="/usr/bin/expect" \
   BIN="/usr/sbin" \
   container="true"
# Use second ENV so that variable get substituted
ENV  INSTALL_SCRIPTS=$INSTALL_DIR/install \
     PATH=/bin:/usr/bin:/sbin:/usr/sbin:$PATH \
     SCRIPT_DIR=$INSTALL_DIR/startup \
     GRID_PATH=$GRID_HOME/bin:$GRID_HOME/OPatch/:/usr/sbin:$PATH  \
     DB_PATH=$DB_HOME/bin:$DB_HOME/OPatch/:/usr/sbin:$PATH \
     GRID_LD_LIBRARY_PATH=$GRID_HOME/lib:/usr/lib:/lib \
     DB_LD_LIBRARY_PATH=$DB_HOME/lib:/usr/lib:/lib

# Copy binaries
# -------------
# COPY Binaries
COPY $GRID_SW_INSTALL_RSP  $INSTALL_GRID_PATCH $SETUP_LINUX_FILE $GRID_SETUP_FILE $INSTALL_GRID_BINARIES_FILE $FIXUP_PREQ_FILE $DB_SETUP_FILE $CHECK_SPACE_FILE $DB_INSTALL_RSP $INSTALL_DB_BINARIES_FILE $ENABLE_RAC_FILE $GRID_HOME_CLEANUP $ORACLE_HOME_CLEANUP $INSTALL_FILE_1 $INSTALL_FILE_2 $INSTALL_SCRIPTS/

# Setup Scripts
COPY $RUN_FILE $ADDNODE $ADDNODE_RSP $SETUPSSH $FUNCTIONS $CONFIGGRID $GRID_INSTALL_RSP $DBCA_RSP $PWD_FILE $CHECK_DB_FILE $USER_SCRIPTS_FILE $STOP_FILE $CHECK_DB_FILE $REMOTE_LISTENER_FILE $SETUPGRIDENV $DELNODE $RESET_OS_PASSWORD $MULTI_NODE_INSTALL  $SCRIPT_DIR/

RUN chmod 755 $INSTALL_SCRIPTS/*.sh  && \
    sync && \
    $INSTALL_DIR/install/$CHECK_SPACE_FILE && \
    $INSTALL_DIR/install/$SETUP_LINUX_FILE && \
    $INSTALL_DIR/install/$GRID_SETUP_FILE && \
    $INSTALL_DIR/install/$DB_SETUP_FILE && \
    sed -e '/hard *memlock/s/^/#/g' -i /etc/security/limits.d/oracle-database-preinstall-19c.conf && \
    su  $GRID_USER -c "$INSTALL_DIR/install/$INSTALL_GRID_BINARIES_FILE EE $PATCH_NUMBER" && \
    $INVENTORY/orainstRoot.sh && \
    $GRID_HOME/root.sh && \
    su  $DB_USER  -c  "$INSTALL_DIR/install/$INSTALL_DB_BINARIES_FILE EE" && \
    su  $DB_USER  -c  "$INSTALL_DIR/install/$ENABLE_RAC_FILE" && \
    $INVENTORY/orainstRoot.sh && \
    $DB_HOME/root.sh && \
    su  $GRID_USER -c "$INSTALL_SCRIPTS/$GRID_HOME_CLEANUP" && \
    su  $DB_USER -c "$INSTALL_SCRIPTS/$ORACLE_HOME_CLEANUP" && \
    $INSTALL_DIR/install/$FIXUP_PREQ_FILE && \
    rm -rf $INSTALL_DIR/install && \
    rm -rf $INSTALL_DIR/install && \
    sync && \
    chmod 755 $SCRIPT_DIR/*.sh && \
    chmod 755 $SCRIPT_DIR/*.expect && \
    chmod 666 $SCRIPT_DIR/*.rsp && \
    echo "nohup $SCRIPT_DIR/runOracle.sh &" >> /etc/rc.local && \
    rm -f /etc/rc.d/init.d/oracle-database-preinstall-19c-firstboot && \
    mkdir -p $GRID_HOME/dockerinit && \
    cp $GRID_HOME/bin/$DOCKERORACLEINIT $GRID_HOME/dockerinit/ && \
    chown $GRID_USER:oinstall $GRID_HOME/dockerinit && \
    chown root:oinstall $GRID_HOME/dockerinit/$DOCKERORACLEINIT && \
    chmod 4755 $GRID_HOME/dockerinit/$DOCKERORACLEINIT && \
    ln -s $GRID_HOME/dockerinit/$DOCKERORACLEINIT /usr/sbin/oracleinit && \
    chmod +x /etc/rc.d/rc.local  && \
    rm -f /etc/sysctl.d/99-oracle-database-preinstall-19c-sysctl.conf && \
    rm -f /etc/sysctl.d/99-sysctl.conf && \
    sync

USER grid
WORKDIR /home/grid
VOLUME ["/common_scripts"]

# Define default command to start Oracle Grid and RAC Database setup.

CMD ["/usr/sbin/oracleinit"]
