FROM quay.io/almalinux/almalinux:8 as builder

ENV DEPS_HOME ${HOME}/deps

RUN mkdir -p ${DEPS_HOME}

RUN dnf -y update && \
    #Cunit comes from the powertools repo (need to install plugins-core for the config manager)
    dnf -y install dnf-plugins-core && yum config-manager --set-enabled powertools && \
    #Ant, junit etc come from the javapackages-tools module
    dnf -y module enable javapackages-tools && \
    # Install system tools and build dependencies required to build all releases of MessageGateway/MSProxy
    dnf -y install --nobest gcc gcc-c++ make cmake3 CUnit CUnit-devel junit ant ant-apache-xalan2 ant-junit ant-contrib libxslt && \
    # Install library dependencies (1/2)
    dnf -y install openssl-devel curl-devel openldap-devel net-snmp-devel libicu-devel icu boost-devel && \
    # Install library dependencies (1/2)
    dnf -y install jansson jansson-devel pam-devel curl-devel && \
    # Install some tools which developers find useful during basic testing
    dnf -y install less wget vim-enhanced dos2unix bc gdb net-tools openssh-clients bzip2 unzip zip && \
    dnf -y install man file which lsof strace python3-devel python3-pip nodejs npm valgrind nc nmap logrotate && \
    # Needed to build rpms in container
    dnf -y install rpm-build

#Get the dependencies we need that aren't packaged (JMS and java treated separately)
RUN wget https://github.com/d3/d3/releases/download/v3.5.6/d3.zip -O ${DEPS_HOME}/d3-3.5.6.zip && \
    wget https://public.dhe.ibm.com/ibmdl/export/pub/software/openliberty/runtime/release/22.0.0.6/openliberty-22.0.0.6.zip -P ${DEPS_HOME} && \
    wget https://repo1.maven.org/maven2/com/fasterxml/jackson/core/jackson-annotations/2.13.3/jackson-annotations-2.13.3.jar -P ${DEPS_HOME} && \
    wget https://repo1.maven.org/maven2/com/fasterxml/jackson/core/jackson-core/2.13.3/jackson-core-2.13.3.jar -P ${DEPS_HOME} && \
    wget https://repo1.maven.org/maven2/com/fasterxml/jackson/core/jackson-databind/2.13.3/jackson-databind-2.13.3.jar -P ${DEPS_HOME} && \
    wget https://repo1.maven.org/maven2/com/fasterxml/jackson/jaxrs/jackson-jaxrs-base/2.13.3/jackson-jaxrs-base-2.13.3.jar -P ${DEPS_HOME} && \
    wget https://repo1.maven.org/maven2/com/fasterxml/jackson/jaxrs/jackson-jaxrs-json-provider/2.13.3/jackson-jaxrs-json-provider-2.13.3.jar -P ${DEPS_HOME} && \
    wget https://repo1.maven.org/maven2/com/fasterxml/jackson/module/jackson-module-jaxb-annotations/2.13.3/jackson-module-jaxb-annotations-2.13.3.jar -P ${DEPS_HOME} && \
    wget https://download.dojotoolkit.org/release-1.17.2/dojo-release-1.17.2-src.zip -O ${DEPS_HOME}/dojo-release-1.17.2-src.zip && \
    wget https://github.com/oria/gridx/archive/refs/tags/v1.3.9.zip -O ${DEPS_HOME}/gridx-1.3.9.zip && \
    wget https://github.com/unicode-org/icu/releases/download/release-71-1/icu4j-71_1.jar -P ${DEPS_HOME}
    
#Get the JMS jars (separate as need to consider whether these are right locations/jars to grab - consider fscontext.jar/providerutil.jar)
RUN wget https://repo1.maven.org/maven2/org/apache/geronimo/specs/geronimo-jms_1.1_spec/1.1.1/geronimo-jms_1.1_spec-1.1.1.jar  -O ${DEPS_HOME}/jms.jar 