FROM centos:7

# Install packages for installing HIRS TPM2 Provisioner
RUN yum -y update && yum clean all

# install build dependencies
RUN yum install -y epel-release cmake make git gcc-c++ doxygen graphviz protobuf-compiler cppcheck python libssh2-devel openssl libcurl-devel log4cplus-devel protobuf-devel re2-devel tpm2-tss-devel tpm2-abrmd-devel && yum clean all && rm -rf /var/cache/yum

# install run time dependencies
RUN yum install -y java-1.8.0 wget util-linux chkconfig sed initscripts coreutils dmidecode trousers tpm-tools && yum clean all && rm -rf /var/cache/yum

# Install PACCOR for Device Info Gathering
RUN mkdir paccor && pushd paccor && wget https://github.com/nsacyber/paccor/releases/download/v1.1.4r2/paccor-1.1.4-2.noarch.rpm && yum -y install paccor-*.rpm && popd && rm -rf /var/cache/yum

# Install Software TPM for Provisioning
RUN mkdir ibmtpm && pushd ibmtpm && wget --no-check-certificate https://downloads.sourceforge.net/project/ibmswtpm2/ibmtpm1332.tar.gz && tar -zxvf ibmtpm1332.tar.gz && cd src && make -j5 && popd && rm ibmtpm1332.tar.gz

# Install TSS for TPM setup
RUN mkdir ibmtss && pushd ibmtss && wget --no-check-certificate https://downloads.sourceforge.net/project/ibmtpm20tss/ibmtss1.6.0.tar.gz && tar -zxvf ibmtss1.6.0.tar.gz && cd utils && make -f makefiletpmc && popd && rm ibmtss1.6.0.tar.gz
