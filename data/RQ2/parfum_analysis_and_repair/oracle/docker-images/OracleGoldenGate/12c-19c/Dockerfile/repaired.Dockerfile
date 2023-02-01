# Copyright (c) 2017 Oracle and/or its affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.

#
# ORACLE GOLDENGATE DOCKER PROJECT
# --------------------------------
#
# Dockerfile for Oracle GoldenGate
#
# REQUIRED FILES TO BUILD THIS IMAGE
# ----------------------------------
#
# From http://www.oracle.com/technetwork/middleware/goldengate/downloads/index.html
#  Download the file for "Oracle GoldenGate 12.x.x.x.x for Oracle on Linux x86-64"
#    - fbo_ggs_Linux_x64_shiphome.zip
#
# HOW TO BUILD THIS IMAGE
# -----------------------
#
# Execute the "dockerBuild.sh" shell script, with the name of the downloaded OGG filename.
# Example:
#      $ ./dockerBuild.sh ~/Downloads/fbo_ggs_Linux_x64_shiphome.zip
#

ARG         BASE_IMAGE=oracle/instantclient:12.2.0.1
FROM      ${BASE_IMAGE}
LABEL       Description="Oracle GoldenGate on Docker" \
            Maintainer="Stephen Balousek <stephen.balousek@oracle.com>"
USER        root

ARG         OGG_VERSION
ARG         OGG_EDITION
ARG         OGG_TARFILE
ARG         BASE_COMMAND

ENV         JAVA_HOME=/usr/lib/jvm/jre \
            OGG_HOME=/u01/app/ogg \
            OGG_DEPLOY_BASE=/u02/ogg \
            PATH=/u01/app/ogg:/u01/app/ogg/bin:/usr/lib/jvm/jre/bin:${PATH} \
            LD_LIBRARY_PATH=/usr/lib/jvm/jre/lib/amd64/server:${LD_LIBRARY_PATH} \
            OGG_VERSION=${OGG_VERSION} \
            OGG_EDITION=${OGG_EDITION} \
            BASE_COMMAND=${BASE_COMMAND}

ADD         ${OGG_TARFILE} ${OGG_HOME}/
COPY        runOracleGoldenGate.sh /
COPY        bin/* /usr/local/bin/

#
# Initial setup
# - This image will be smaller if the oracle:oinstall user has the numeric identifiers 54321:54321
# - 'vi' is used by the Oracle GoldenGate 'ggsci' utility to edit parameter
#    files and must be run from inside the container.
# - Installation of additional software packages depends on the value of ${OGG_EDITION}
#