# LICENSE UPL 1.0
#
# ORACLE DOCKERFILES PROJECT
# --------------------------
# This is the Dockerfile for Coherence 12.2.1 Quick Install Distribution
# 
# REQUIRED BASE IMAGE TO BUILD THIS IMAGE
# ---------------------------------------
# This Dockerfile requires the base image oracle/serverjre:8
# (see https://github.com/oracle/docker-images/tree/master/OracleJava)
#
# REQUIRED FILES TO BUILD THIS IMAGE
# ----------------------------------
# (1) fmw_12.2.1.0.0_coherence_quick_Disk1_1of1
#
#     Download the Quick installer from http://www.oracle.com/technetwork/middleware/coherence/downloads/index.html
#
# HOW TO BUILD THIS IMAGE
# -----------------------
# Put all downloaded files in the same directory as this Dockerfile
# Run: 
#      $ sh buildDockerImage.sh -q
#
# or if your Docker client requires root access you can run:
#      $ sudo sh buildDockerImage.sh -q
#

# Pull base image
# ---------------
FROM oracle/serverjre:8

# Maintainer
# ----------
MAINTAINER Jonathan Knight

# Environment variables required for this build (do NOT change)
ENV FMW_PKG=fmw_12.2.1.0.0_coherence_quick_Disk1_1of1.zip \
    FMW_JAR=fmw_12.2.1.0.0_coherence_quick.jar \
    ORACLE_HOME=/u01/oracle/oracle_home \
    PATH=$PATH:/usr/java/default/bin:/u01/oracle/oracle_home/oracle_common/common/bin \
    CONFIG_JVM_ARGS="-Djava.security.egd=file:/dev/./urandom"

ENV COHERENCE_HOME=$ORACLE_HOME/coherence

RUN mkdir -p /u01 && \
   useradd -b /u01 -d /u01/oracle -m -s /bin/bash oracle

# Copy files required to build this image
COPY $FMW_PKG install.file oraInst.loc /u01/
COPY start.sh                          /start.sh
COPY extend-cache-config.xml           $COHERENCE_HOME/conf/extend-cache-config.xml

RUN chmod 755 /start.sh && \
   chmod a+xr /u01 && \
   chown -R oracle:oracle /u01

USER oracle

# Install and configure Oracle JDK
# Setup required packages (unzip), filesystem, and oracle user
# ------------------------------------------------------------
RUN cd /u01 && $JAVA_HOME/bin/jar xf /u01/$FMW_PKG && cd - && \
    $JAVA_HOME/bin/java -jar /u01/$FMW_JAR -silent -responseFile /u01/install.file -invPtrLoc /u01/oraInst.loc -jreLoc $JAVA_HOME -ignoreSysPrereqs -force -novalidation ORACLE_HOME=$ORACLE_HOME && \
    rm /u01/$FMW_JAR /u01/$FMW_PKG /u01/oraInst.loc /u01/install.file

ENTRYPOINT ["/start.sh"]
