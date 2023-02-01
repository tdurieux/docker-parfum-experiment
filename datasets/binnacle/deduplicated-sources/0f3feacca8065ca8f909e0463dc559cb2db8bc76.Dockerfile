# LICENSE CDDL 1.0 + GPL 2.0
#
# ORACLE DOCKERFILES PROJECT
# --------------------------
# This is the Dockerfile for SOA Suite 12.1.3 Quick Start Distro
# 
# IMPORTANT
# ---------
# The resulting image of this Dockerfile DOES NOT contain a SOA Suite Domain.
# For that, look into the folder 'samples' for an example on how
# to create a domain on a new inherited image.
#
# You can go into 'samples/12c-domain' after building the generic raw image
# and build that image, for example:
# 
#   $ cd samples/12c-domain
#   $ sudo docker build -t mysoa .
#
# REQUIRED FILES TO BUILD THIS IMAGE
# ----------------------------------
# (1) fmw_12.1.3.0.0_soaqs_Disk1_1of1.zip
#     Download the Quick Start installer from http://www.oracle.com/technetwork/middleware/soasuite/downloads/index.html
#
# (2) jdk-7u75-linux-x64.rpm
#     Download from http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html
#
# HOW TO BUILD THIS IMAGE
# ------------------w-----
# Put all downloaded files in the same directory as this Dockerfile
# Run: 
#      $ sudo docker build -t oracle/soa:12.1.3-dev . 
#
# Pull base image
# ---------------
FROM oraclelinux:7

# Maintainer
# ----------
MAINTAINER Jorge Quilcate <quilcate.jorge@gmail.com>

# Environment variables required for this build (do NOT change)
# -------------------------------------------------------------
ENV JAVA_RPM jdk-7u75-linux-x64.rpm
ENV SOA_ZIP fmw_12.1.3.0.0_soaqs_Disk1_1of1.zip
ENV SOA_PKG fmw_12.1.3.0.0_soa_quickstart.jar
ENV SOA_PKG2 fmw_12.1.3.0.0_soa_quickstart2.jar
ENV JAVA_HOME /usr/java/default
ENV MW_HOME /u01/oracle/soa
ENV CONFIG_JVM_ARGS -Djava.security.egd=file:/dev/./urandom

# SETUP FILESYSTEM AND ORACLE USER
# ------------------------------------------------------------
RUN mkdir /u01 && chmod a+xr /u01 && \
    useradd -b /u01 -m -s /bin/bash oracle

# Copy packages
ADD $SOA_ZIP /u01/
COPY $JAVA_RPM /u01/
COPY install.file /u01/
COPY oraInst.loc /u01/

# Install and configure Oracle JDK 7u75
# -------------------------------------
RUN rpm -i /u01/$JAVA_RPM && \ 
    rm /u01/$JAVA_RPM
    
# Change the open file limits in /etc/security/limits.conf
RUN sed -i '/.*EOF/d' /etc/security/limits.conf && \
    echo "* soft nofile 16384" >> /etc/security/limits.conf && \ 
    echo "* hard nofile 16384" >> /etc/security/limits.conf && \ 
    echo "# EOF"  >> /etc/security/limits.conf

# Change the kernel parameters that need changing.
RUN echo "net.core.rmem_max=4192608" > /u01/oracle/.sysctl.conf && \
    echo "net.core.wmem_max=4192608" >> /u01/oracle/.sysctl.conf && \ 
    sysctl -e -p /u01/oracle/.sysctl.conf

# Unzip SOA Suite installer
WORKDIR /u01

# Adjust file permissions, go to /u01 as user 'oracle' to proceed with SOA Suite installation
# Installation of SOA Suite 
# Remove packages
RUN mkdir /u01/oracle/.inventory && \
chown oracle:oracle -R /u01 && \
jar xf $SOA_ZIP && \
su oracle -c "java -jar $SOA_PKG -ignoreSysPrereqs -novalidation -silent -responseFile /u01/install.file -invPtrLoc /u01/oraInst.loc -jreLoc $JAVA_HOME" && \
rm $SOA_PKG $SOA_PKG2 /u01/$SOA_ZIP /u01/oraInst.loc /u01/install.file

WORKDIR /u01/oracle/

ENV PATH $PATH:/u01/oracle/soa/oracle_common/common/bin

# Define default command to start bash. 
CMD ["bash"]