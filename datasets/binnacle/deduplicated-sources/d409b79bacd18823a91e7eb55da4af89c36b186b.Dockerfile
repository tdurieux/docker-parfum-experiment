#
# Dockerfile template for Tuxedo ART 12.2.2
# 
# Pull base image
FROM oracle/tuxedo:12.2.2

MAINTAINER Judy Liu <judy.liu@oracle.com>

# Create the installation directory tree and user oracle with a password of oracle
USER root
RUN yum -y install perl perl-CPAN ksh mksh sudo make vim tar net-tools dos2unix tk tcl-devel tk-devel gtk2 expect libaio openssh-client rsync && yum -y clean all 

#Set environments
ENV ORACLE_HOME=/usr/lib/oracle/12.2/client64 \
    PATH=/usr/java/default/bin:$PATH \
    TMPFILES=/tmp/files \
    ARTRT_PKG=art122200_64_linux_x86_64.zip \
    ORACLT_PKG1=oracle-instantclient12.2-basic-12.2.0.1.0-1.x86_64.rpm \
    ORACLT_PKG2=oracle-instantclient12.2-sqlplus-12.2.0.1.0-1.x86_64.rpm \
    ORACLT_PKG3=oracle-instantclient12.2-devel-12.2.0.1.0-1.x86_64.rpm \
    ORACLT_PKG4=oracle-instantclient12.2-precomp-12.2.0.1.0-1.x86_64.rpm

#Install COBOL-IT
ADD bin/cobol-it*.gz /opt/ 

# Copy packages
# -------------
COPY bin/$ORACLT_PKG1 bin/$ORACLT_PKG2 bin/$ORACLT_PKG3 bin/$ORACLT_PKG4 \
     tuxedoartrt12.2.2.rsp bin/$ARTRT_PKG init.sh \
     bin/p*.zip /u01/
RUN  mv /u01/init.sh /u01/oracle/init.sh && \
     chown oracle:oracle -R /u01 && \
     chmod +x /u01/oracle/init.sh

# Setup filesystem and oracle user, install required packages including Oracle Instant Client
# ------------------------------------------------------------
WORKDIR /u01/
RUN yum install -y $ORACLT_PKG1  $ORACLT_PKG2 $ORACLT_PKG3 $ORACLT_PKG4 && \
    rm -f $ORACLT_PKG1 $ORACLT_PKG2 $ORACLT_PKG3 $ORACLT_PKG4 non_exist_file && \
    yum clean all && \
    chown oracle:oracle -R /u01/

#Install Tuxedo ART
USER oracle
ENV ORACLE_HOME=/u01/oracle/tuxHome
RUN cd /u01 && \
      mkdir -p oraInventory && \
      jar xf $ARTRT_PKG && \
      cd /u01/Disk1/install && \
      chmod -R +x * && \
      ./runInstaller.sh -responseFile /u01/tuxedoartrt12.2.2.rsp -silent -waitforcompletion && \
      rm -rf /u01/Disk1 \
             /u01/tuxedoartrt12.2.2.rsp \
             /u01/$ARTRT_PKG

# Install Tuxedo and ART Patches
RUN cd /u01/oracle && \
    ln -s $JAVA_HOME tuxHome/jdk && \
    for patch_file in `/bin/ls /u01/p*.zip`; do \
      if [ "`/bin/ls -l $patch_file|cut -c8`" != r ];then \
         chmod a+r $patch_file; \
      fi;  \
      cd /u01/oracle; \
      mkdir -p tmp ; cd tmp;  \
      jar xf $patch_file; \
      tux_patch=`find . -name *.zip`; \
      /u01/oracle/tuxHome/OPatch/opatch apply $tux_patch; \
      cd ; rm -rf tmp $patch_file; \
    done

USER oracle
WORKDIR /u01/oracle

EXPOSE 22 8080


# Define ENTRYPOINT. 
ENTRYPOINT ["/u01/oracle/init.sh"]
