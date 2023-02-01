# LICENSE UPL 1.0
#
# Copyright (c) 2018 Oracle and/or its affiliates. All rights reserved.
#
# ORACLE DOCKERFILES PROJECT
# --------------------------
# This Dockerfile extends the Oracle WebLogic MSI server image by adding app
# bits to the image and recording it in domain configuration
#
# REQUIRED FILES TO BUILD THIS IMAGE
# ----------------------------------
#
# HOW TO BUILD THIS IMAGE
# -----------------------
# Run the following command for the sample application included in this directory. The name and source identify
# the name of the applciation to be used and the application source. simple_file identified the simple file name
# that will be used to copy the source file on the image. It can be the same as the last element of application
# source
#      $ sudo docker build -t 12212-summercamps-msiserver -f Dockerfile.addapp --build-arg name=summercamps  --build-arg source=apps/summercamps.ear --build-arg simple_filename=summercamps.ear .
#

# Pull base image
# ---------------
FROM 12212-msiserver:latest

# Maintainer
# ----------
MAINTAINER Aseem Bajaj <aseem.bajaj@oracle.com>

# Arguments
# ---------
ARG name=summercamps
ARG source=apps/summercamps.ear
ARG simple_filename=summercamps.ear

# Environment variables required for this build (do NOT change)
# -------------------------------------------------------------
ENV MW_HOME="$ORACLE_HOME" \
    PATH="$ORACLE_HOME/wlserver/server/bin:$ORACLE_HOME/wlserver/../oracle_common/modules/org.apache.ant_1.9.2/bin:$JAVA_HOME/jre/bin:$JAVA_HOME/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$ORACLE_HOME/oracle_common/common/bin:$ORACLE_HOME/wlserver/common/bin:$ORACLE_HOME/user_projects/domains/medrec/bin:$ORACLE_HOME/wlserver/samples/server/medrec/:$ORACLE_HOME/wlserver/samples/server/:$ORACLE_HOME/wlserver/../oracle_common/modules/org.apache.maven_3.2.5/bin"

# Copy scripts
# --------------------------------
USER oracle
COPY ${source} /u01/apps/${simple_filename}

# WLST offline use to update domain configuration
# ---------------------------------------------
RUN . $ORACLE_HOME/wlserver/server/bin/setWLSEnv.sh && \
    java weblogic.WLST /u01/oracle/add-app-to-domain.py $DOMAINS_DIR/$DOMAIN_NAME $NUMBER_OF_MS $name /u01/apps/${simple_filename} $MS_NAME_PREFIX
