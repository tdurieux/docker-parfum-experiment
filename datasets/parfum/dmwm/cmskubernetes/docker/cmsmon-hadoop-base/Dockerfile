FROM registry.cern.ch/cmsmonitoring/cmsmon-py:3.9.13
MAINTAINER Ceyhun Uzunoglu ceyhunuzngl@gmail.com

ARG HADOOP_VERSION
ARG SPARK_VERSION
ARG SPARK_MAJOR_VERSION

ENV WDIR=/data
WORKDIR $WDIR
ADD http://repository.egi.eu/sw/production/cas/1/current/repo-files/EGI-trustanchors.repo /etc/yum.repos.d/egi.repo
ADD http://linuxsoft.cern.ch/wlcg/wlcg-centos7.repo /etc/yum.repos.d/wlcg-centos7.repo
ADD hadoop.repo /etc/yum.repos.d/hadoop.repo
ADD epel.repo /etc/yum.repos.d/epel.repo
ADD slc7-cernonly.repo /etc/yum.repos.d/slc7-cernonly.repo
ADD RPM-GPG-KEY-wlcg /etc/pki/rpm-gpg/RPM-GPG-KEY-wlcg

ENV PATH $PATH:/usr/hdp/hadoop/bin:/usr/hdp/sqoop/bin
ENV PATH $PATH:/data

# add necessary RPMs for cmsweb deployment
RUN yum -y update && \
    yum install -y  \
        cern-get-certificate fetch-crl \
        git-core zip unzip which file bzip2 e2fsprogs e2fsprogs-libs compat-libstdc++-33 \
        CERN-CA-certs ca-certificates dummy-ca-certs ca-policy-lcg ca-policy-egi-core \
        ca_EG-GRID ca_CERN-GridCA ca_CERN-LCG-IOTA-CA ca_CERN-Root-2 \
        wlcg-voms-cms krb5-workstation krb5-libs pam_krb5 myproxy voms-clients-cpp voms-clients-java \
        sudo openssl openssl-devel openssl-libs openssh openssh-clients python-backports-ssl_match_hostname \
        cmake voms voms-devel globus-gsi-credential-devel globus-gsi-cert-utils-devel \
        globus-common-devel globus-gsi-sysconfig globus-gsi-sysconfig-devel globus-gsi-callback-devel \
        globus-gsi-openssl-error globus-gsi-proxy-ssl globus-openssl-module \
        shibboleth log4shib xmltooling-schemas opensaml-schemas \
        perl-Thread-Queue zsh tk freetype perl-ExtUtils-Embed fontconfig \
        perl-Test-Harness perl-Data-Dumper perl-Digest-MD5 perl-Switch perl-Env \
        libX11-devel libX11 libXmu libSM libICE libXcursor libXext libXrandr libXft \
        mesa-libGLU mesa-libGL libXi libXinerama libXft-devel libXrender libXpm \
        libXpm-devel libXext-devel mesa-libGLU-devel \
        libaio libaio-devel net-tools lsof bind-utils initscripts patch \
        voms-devel globus-gsi-credential-devel globus-gsi-cert-utils-devel \
        globus-common-devel globus-gsi-sysconfig-devel globus-gsi-callback-devel \
        oracle-instantclient-tnsnames.ora HEP_OSlibs python-pip libffi-devel \
        hadoop-bin-${HADOOP_VERSION} \
        spark-bin-${SPARK_VERSION} \
        sqoop-bin-1.4 \
        cern-hadoop-xrootd-connector  \
        cern-hadoop-config && \
    yum clean all && rm -rf /var/cache/yum && \
    hadoop-set-default-conf.sh analytix && \
    source hadoop-setconf.sh analytix ${HADOOP_VERSION} ${SPARK_MAJOR_VERSION} && \
    touch /etc/hadoop/conf/topology.table.file && ln -s /bin/bash /usr/bin/bashs && \
    echo "32 */6 * * * root ! /usr/sbin/fetch-crl -q -r 360" > /etc/cron.d/fetch-crl-docker
    # add fetch-crl to fetch all sertificates

RUN if [ "$SPARK_MAJOR_VERSION" = "spark3" ] ; then \
# set default python as python3 if spark3
        rm -f /usr/bin/python && ln -s /usr/bin/python3 /usr/bin/python && \
        rm -f /usr/bin/pip && ln -s /usr/bin/pip3 /usr/bin/pip && \
# copy spark3 entrypoint.sh
        cp /usr/hdp/spark3/kubernetes/dockerfiles/spark/entrypoint.sh /usr/bin/entrypoint.sh; \
    else  \
# copy spark2 entrypoint.sh
        cp /usr/hdp/spark/kubernetes/dockerfiles/spark/entrypoint.sh /usr/bin/entrypoint.sh; \
  fi

# start the setup
WORKDIR ${WDIR}
