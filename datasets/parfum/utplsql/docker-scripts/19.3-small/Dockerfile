# REQUIRED FILES TO BUILD THIS IMAGE
# ----------------------------------
# (1) db_home.zip
#     Download Oracle Database 19c Standard Edition 2 for Linux x64
#     from http://www.oracle.com/technetwork/database/enterprise-edition/downloads/index.html
#
# HOW TO BUILD THIS IMAGE
# -----------------------
# Put all downloaded files in the same directory as this Dockerfile
# Run: 
#      $ docker build -t utplsql/oracledb:19.3.0-se2 . 
#
# Pull base image
# ---------------
FROM oraclelinux:7-slim

# Maintainer
# ----------
LABEL maintainer="Pavel Kaplya <pazus@utplsql.org>" \
      description="Oracle 19c database. Based on official docker images by Gerald Venzl (Oracle) - \
https://github.com/oracle/docker-images/tree/master/OracleDatabase/SingleInstance/dockerfiles"

# Environment variables required for this build (do NOT change)
# -------------------------------------------------------------
ENV ORACLE_BASE=/opt/oracle \
    ORACLE_HOME=/opt/oracle/product/19c/dbhome_1 \
    PDB_BASE_DIR=/opt/oracle/oradata/pdbs \
    INSTALL_FILE_1="LINUX.X64_193000_db_home.zip" \
    INSTALL_RSP="db_inst.rsp" \
    CONFIG_RSP="dbca.rsp.tmpl" \
    DB_TEMPLATE_FILE="MinimalDB.dbt" \
    PWD_FILE="setPassword.sh" \
    RUN_FILE="runOracle.sh" \
    START_FILE="startDB.sh" \
    STOP_FILE="stopDB.sh" \
    CREATE_DB_FILE="createDB.sh" \
    CLEANUP_DB_FILE="cleanupDB.sh" \
    PREPARE_DB_FILE="prepareDB.sh" \
    CREATE_PDB_FILE="createPDB.sh" \
    SETUP_LINUX_FILE="setupLinuxEnv.sh" \
    CLEANUP_FILE="cleanup.sh" \
    CHECK_SPACE_FILE="checkSpace.sh" \
    INSTALL_DB_BINARIES_FILE="installDBBinaries.sh" \
    ORACLE_PWD="oracle" \
    ORACLE_PDB="ORCLPDB1" \
    ORACLE_SID="ORCLCDB" \
    CREATE_PDB="false"

# Use second ENV so that variable get substituted
ENV INSTALL_DIR=$ORACLE_BASE/install \
    PATH=$ORACLE_HOME/bin:$ORACLE_HOME/OPatch/:/usr/sbin:$PATH \
    LD_LIBRARY_PATH=$ORACLE_HOME/lib:/usr/lib \
    CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib

# Copy binaries
# -------------
COPY $INSTALL_FILE_1 $INSTALL_RSP $SETUP_LINUX_FILE $CHECK_SPACE_FILE $INSTALL_DB_BINARIES_FILE $INSTALL_DIR/
COPY $RUN_FILE $START_FILE $STOP_FILE $CREATE_DB_FILE $CREATE_PDB_FILE $CONFIG_RSP $PWD_FILE $CLEANUP_FILE $CLEANUP_DB_FILE $PREPARE_DB_FILE $DB_TEMPLATE_FILE $ORACLE_BASE/

RUN chmod ug+x $INSTALL_DIR/*.sh && \
    sync && \
    $INSTALL_DIR/$CHECK_SPACE_FILE && \
    $INSTALL_DIR/$SETUP_LINUX_FILE

# Install DB software binaries
USER oracle
RUN $INSTALL_DIR/$INSTALL_DB_BINARIES_FILE SE2

USER root
RUN $ORACLE_BASE/oraInventory/orainstRoot.sh && \
    $ORACLE_HOME/root.sh && \
    rm -rf $INSTALL_DIR

USER oracle
RUN chmod ug+x $ORACLE_BASE/*.sh && \
    $ORACLE_BASE/$CREATE_DB_FILE && \
    $ORACLE_BASE/$CLEANUP_DB_FILE && \
    $ORACLE_BASE/$STOP_FILE && \
    $ORACLE_BASE/$CLEANUP_FILE

WORKDIR /home/oracle

VOLUME ["$PDB_BASE_DIR"]
EXPOSE 1521 5500
    
# Define default command to start Oracle Database. 
CMD $ORACLE_BASE/$RUN_FILE
