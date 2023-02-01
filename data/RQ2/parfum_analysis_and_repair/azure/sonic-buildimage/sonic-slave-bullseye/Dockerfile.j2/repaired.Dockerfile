{% set prefix = DEFAULT_CONTAINER_REGISTRY %}
{%- if CONFIGURED_ARCH == "armhf" and MULTIARCH_QEMU_ENVIRON == "y" %}
FROM {{ prefix }}multiarch/qemu-user-static:x86_64-arm-6.1.0-8 as qemu
FROM {{ prefix }}multiarch/debian-debootstrap:armhf-bullseye
COPY --from=qemu /usr/bin/qemu-arm-static /usr/bin
{%- elif CONFIGURED_ARCH == "arm64" and MULTIARCH_QEMU_ENVIRON == "y" %}
FROM {{ prefix }}multiarch/qemu-user-static:x86_64-aarch64-6.1.0-8 as qemu
FROM {{ prefix }}multiarch/debian-debootstrap:arm64-bullseye
COPY --from=qemu /usr/bin/qemu-aarch64-static /usr/bin
{%- else -%}
FROM {{ prefix }}debian:bullseye
{%- endif %}

MAINTAINER gulv@microsoft.com

COPY ["no-check-valid-until", "/etc/apt/apt.conf.d/"]

## TODO: Re-add in any necessary mirror URLs here as they become available
RUN echo "deb [arch=amd64] http://debian-archive.trafficmanager.net/debian/ bullseye main contrib non-free" >> /etc/apt/sources.list && \
        echo "deb-src [arch=amd64] http://debian-archive.trafficmanager.net/debian/ bullseye main contrib non-free" >> /etc/apt/sources.list && \
        echo "deb [arch=amd64] http://debian-archive.trafficmanager.net/debian-security/ bullseye-security main contrib non-free" >> /etc/apt/sources.list && \
        echo "deb-src [arch=amd64] http://debian-archive.trafficmanager.net/debian-security/ bullseye-security main contrib non-free" >> /etc/apt/sources.list && \
        echo "deb [arch=amd64] http://debian-archive.trafficmanager.net/debian bullseye-backports main" >> /etc/apt/sources.list && \
        echo "deb [arch=amd64] http://packages.trafficmanager.net/debian/debian-security bullseye-security main contrib non-free" >> /etc/apt/sources.list && \
        echo "deb [arch=amd64] http://packages.trafficmanager.net/debian/debian bullseye main contrib non-free" >> /etc/apt/sources.list && \
        echo "deb [arch=amd64] http://packages.trafficmanager.net/debian/debian bullseye-updates main contrib non-free" >> /etc/apt/sources.list

{%- if CONFIGURED_ARCH == "armhf" %}
RUN echo "deb [arch=armhf] http://deb.debian.org/debian bullseye main contrib non-free" > /etc/apt/sources.list && \
        echo "deb-src [arch=armhf] http://deb.debian.org/debian bullseye main contrib non-free" >> /etc/apt/sources.list && \
        echo "deb [arch=armhf] http://deb.debian.org/debian bullseye-updates main contrib non-free" >> /etc/apt/sources.list && \
        echo "deb-src [arch=armhf] http://deb.debian.org/debian bullseye-updates main contrib non-free" >> /etc/apt/sources.list && \
        echo "deb [arch=armhf] http://security.debian.org bullseye-security main contrib non-free" >> /etc/apt/sources.list && \
        echo "deb-src [arch=armhf] http://security.debian.org bullseye-security main contrib non-free" >> /etc/apt/sources.list && \
        echo 'deb [arch=armhf] http://ftp.debian.org/debian bullseye-backports main' >> /etc/apt/sources.list && \
        echo "deb [arch=armhf] http://packages.trafficmanager.net/debian/debian-security bullseye-security main contrib non-free" >> /etc/apt/sources.list && \
        echo "deb [arch=armhf] http://packages.trafficmanager.net/debian/debian bullseye main contrib non-free" >> /etc/apt/sources.list && \
        echo "deb [arch=armhf] http://packages.trafficmanager.net/debian/debian bullseye-updates main contrib non-free" >> /etc/apt/sources.list
{%- elif CONFIGURED_ARCH == "arm64" %}
RUN echo "deb [arch=arm64] http://deb.debian.org/debian bullseye main contrib non-free" > /etc/apt/sources.list && \
        echo "deb-src [arch=arm64] http://deb.debian.org/debian bullseye main contrib non-free" >> /etc/apt/sources.list && \
        echo "deb [arch=arm64] http://deb.debian.org/debian bullseye-updates main contrib non-free" >> /etc/apt/sources.list && \
        echo "deb-src [arch=arm64] http://deb.debian.org/debian bullseye-updates main contrib non-free" >> /etc/apt/sources.list && \
        echo "deb [arch=arm64] http://security.debian.org bullseye-security main contrib non-free" >> /etc/apt/sources.list && \
        echo "deb-src [arch=arm64] http://security.debian.org bullseye-security main contrib non-free" >> /etc/apt/sources.list && \
        echo "deb [arch=arm64] http://packages.trafficmanager.net/debian/debian-security bullseye-security main contrib non-free" >> /etc/apt/sources.list && \
        echo 'deb [arch=arm64] http://ftp.debian.org/debian bullseye-backports main' >> /etc/apt/sources.list && \
        echo "deb [arch=arm64] http://packages.trafficmanager.net/debian/debian bullseye main contrib non-free" >> /etc/apt/sources.list && \
        echo "deb [arch=arm64] http://packages.trafficmanager.net/debian/debian bullseye-updates main contrib non-free" >> /etc/apt/sources.list
{%- endif %}

## Make apt-get non-interactive
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y \
        apt-utils \
        default-jre-headless \
        openssh-server \
        curl \
        wget \
        unzip \
        git \
        build-essential \
        libtool \
        lintian \
        sudo \
        dh-make \
        dh-exec \
        kmod \
        libtinyxml2-dev \
        python-all \
        python-dev \
        python-setuptools \
        python3 \
        python3-pip \
        libncurses5-dev \
        texinfo \
        dh-autoreconf \
        doxygen \
        devscripts \
        git-buildpackage \
        perl-modules \
        libclass-accessor-perl \
        libswitch-perl \
        libzmq5 \
        libzmq3-dev \
        jq \
        cron \

        libreadline-dev \
        texlive-latex-base \
        texlive-plain-generic \
        texlive-fonts-recommended \
        libpam0g-dev \
        libpam-dev \
        libcap-dev \
        imagemagick \
        ghostscript \
        groff \
        libpcre3-dev \
        gawk \
        chrpath \

        libc-ares-dev \
        libsnmp-dev \
        libjson-c-dev \
        libsystemd-dev \
        python3-ipaddr \
        libcmocka-dev \
        python3-all-dev \
        python3-all-dbg \
        install-info \
        logrotate \

        cdbs \

        libxml-simple-perl \
        graphviz \
        aspell \

        bc \
        fakeroot \
        build-essential \
        devscripts \
        quilt \
        stgit \
        sbsigntool \

        module-assistant \

        gem2deb \
        libevent-dev \
        libglib2.0-dev \
        python3-all-dev \
        python3-twisted \
        phpunit \
        libbit-vector-perl \
        openjdk-11-jdk \
        javahelper \
        maven-debian-helper \
        ant \
        libhttpclient-java \
        libslf4j-java \
        libservlet3.1-java \
        pkg-php-tools \

        libpcre3 \
        libpcre3-dev \
        byacc \
        flex \
        libglib2.0-dev \
        bison \
        expat \
        libexpat1-dev \
        dpatch \
        libdb-dev \
        libiptc-dev \
        libxtables-dev \

        libtool-bin \
        libxml2-dev \

        libusb-1.0-0-dev \
        libcurl3-nss-dev \
        libunwind8-dev \
        telnet \
        libc-ares2 \
        libgoogle-perftools4 \

        cpio \
        squashfs-tools \
        zip \

{%- if CONFIGURED_ARCH == "amd64" %} && rm -rf /var/lib/apt/lists/*;
        linux-compiler-gcc-10-x86 \
{%- endif %}
{%- if CONFIGURED_ARCH == "armhf" %}
        linux-compiler-gcc-10-arm \
{%- endif %}
        linux-kbuild-5.10 \
# teamd build
        libdaemon-dev \
        libdbus-1-dev \
        libjansson-dev \
# For cavium sdk build
        libpcap-dev \
        dnsutils \
        libusb-dev \
# For debian image reconfiguration
        augeas-tools \
# For p4 build
        libyaml-dev \
        libevent-dev \
        libjudy-dev \
        libedit-dev \
        libnanomsg-dev \
        python3-stdeb \
# For redis build
        libjemalloc-dev \
        liblua5.1-0-dev \
        lua-bitop-dev  \
        lua-cjson-dev \
# For mft kernel module build
        dkms \
# For Jenkins static analysis, unit testing and code coverage
        cppcheck \
        clang \
        pylint \
        python3-pytest \
        python3-venv \
        gcovr \
        python3-pytest-cov \
        python3-pytest-cov \
        python3-parse \
# For snmpd
        default-libmysqlclient-dev \
        libssl-dev \
        libperl-dev \
        libpci-dev \
        libpci3 \
        libsensors5 \
        libsensors4-dev \
        libwrap0-dev \
# For lldpd
	debhelper \
        autotools-dev \
        libbsd-dev \
        pkg-config \
        check \
# For mpdecimal
        docutils-common \
        libjs-sphinxdoc \
        libjs-underscore \
        python3-docutils \
        python3-jinja2 \
        python3-markupsafe \
        python3-pygments \
        python3-roman \
        python3-sphinx \
        sphinx-common \
        python3-sphinx \
# For sonic config engine testing
        python3-dev \
{%- if CONFIGURED_ARCH == "armhf" or CONFIGURED_ARCH == "arm64" %}
        libxslt-dev \
{%- endif %}
# For lockfile
        procmail \
# For gtest
        libgtest-dev \
        cmake \
# For gmock
        libgmock-dev \
# For pam_tacplus build
        autoconf-archive \
# For iproute2
        cm-super-minimal \
        libatm1-dev \
        libelf-dev \
        libmnl-dev \
        libselinux1-dev \
        linuxdoc-tools \
        lynx \
        texlive-latex-extra \
        texlive-latex-recommended \
        iproute2 \
# For bash
        texi2html \
        sharutils \
        locales \
        time \
        man2html-base \
        libcunit1 \
        libcunit1-dev \
# For initramfs
        shellcheck \
        bash-completion \
{%- if CONFIGURED_ARCH == "amd64" %}
# For sonic vs image build
        dosfstools \
        qemu-kvm \
        libvirt-clients \
{%- endif %}
# For ntp
        autogen \
        libopts25-dev \
        pps-tools \
        dh-apparmor \
# For lm-sensors
        librrd8 \
        librrd-dev \
        rrdtool \
# For kdump-tools
        liblzo2-dev \
# For iptables
        libnetfilter-conntrack-dev \
        libnftnl-dev \
# For SAI3.7
        protobuf-compiler \
        libprotobuf-dev \
        xxd \
# For DHCP Monitor tool
        libexplain-dev \
        libevent-dev \
# For libyang
        swig \
# For build dtb
        device-tree-compiler \
# For sonic-mgmt-framework
        autoconf \
        m4 \
        libxml2-utils \
        xsltproc \
        python3-lxml \
        libexpat1-dev \
        libcurl3-gnutls \
        libcjson-dev \
# For WPA supplication
        qtbase5-dev          \
        aspell-en            \
        libssl-dev           \
        dbus                 \
        libdbus-1-dev        \
        libdbus-glib-1-2     \
        libdbus-glib-1-dev   \
        libreadline-dev      \
        libncurses5-dev      \
        libpcsclite-dev      \
        docbook-to-man       \
        docbook-utils        \
# For kdump-tools
        libbz2-dev \
# For linkmgrd
        libboost-dev \
        libboost-program-options-dev \
        libboost-system-dev \
        libboost-thread-dev \
        libboost-atomic-dev \
        libboost-chrono-dev \
        libboost-container-dev \
        libboost-context-dev \
        libboost-contract-dev \
        libboost-coroutine-dev \
        libboost-date-time-dev \
        libboost-fiber-dev \
        libboost-filesystem-dev \
        libboost-graph-parallel-dev \
        libboost-log-dev \
        libboost-regex-dev \
        googletest \
        libgtest-dev \
        libgmock-dev \
        libgcc-10-dev \
# For sonic-host-services build
        libcairo2-dev \
        libdbus-1-dev \
        libgirepository1.0-dev \
        libsystemd-dev \
        pkg-config \
# For audisp-tacplus
        libauparse-dev \
        auditd

RUN apt-get -y build-dep openssh

# Build fix for ARM64 and ARMHF /etc/debian_version
{%- if CONFIGURED_ARCH == "armhf" or CONFIGURED_ARCH == "arm64" %}
RUN apt upgrade -y base-files
{%- endif %}

# Build fix for ARMHF bullseye libsairedis
{%- if CONFIGURED_ARCH == "armhf" %}
       # Install doxygen build dependency packages
       RUN apt install --no-install-recommends -y libxapian-dev yui-compressor texlive-extra-utils \
           texlive-font-utils rdfind llvm-11-dev libclang-11-dev sassc faketime mat2 && rm -rf /var/lib/apt/lists/*;

       # Update doxygen with 64bit file offset patch
       RUN dget -u http://deb.debian.org/debian/pool/main/d/doxygen/doxygen_1.9.1-2.dsc && \
           cd doxygen-1.9.1 && \
           sed -i '56 a add_definitions(-D_FILE_OFFSET_BITS=64)' CMakeLists.txt && \
           DEB_BUILD_OPTIONS=nocheck dpkg-buildpackage -us -uc -b && \
           cd .. && \
           dpkg -i ./doxygen_1.9.1-2_armhf.deb && \
           rm -fr doxygen*

       # Aspell is unable to locate the language dictionaries.
       # Re-installing aspell-en dictionary to fix it.
       RUN apt-get install --no-install-recommends --reinstall -y aspell-en && rm -rf /var/lib/apt/lists/*;

       # workaround because of https://bugs.launchpad.net/qemu/+bug/1805913, just disable aspell
       # Issue now being tracked here - https://gitlab.com/qemu-project/qemu/-/issues/263
       RUN cp /bin/true /usr/bin/aspell
{%- endif %}

## Config dpkg
## install the configuration file if it’s currently missing
RUN sudo augtool --autosave "set /files/etc/dpkg/dpkg.cfg/force-confmiss"
## combined with confold: overwrite configuration files that you have not modified
RUN sudo augtool --autosave "set /files/etc/dpkg/dpkg.cfg/force-confdef"
## do not modify the current configuration file, the new version is installed with a .dpkg-dist suffix
RUN sudo augtool --autosave "set /files/etc/dpkg/dpkg.cfg/force-confold"

# For linux build
RUN apt-get -y build-dep linux

# For gobgp and telemetry build
RUN apt-get install --no-install-recommends -y golang-1.15 && ln -s /usr/lib/go-1.15 /usr/local/go && rm -rf /var/lib/apt/lists/*;
{%- if ENABLE_FIPS_FEATURE == "y" %}
RUN wget -O golang-go.deb 'https://sonicstorage.blob.core.windows.net/public/fips/bullseye/0.1/{{ CONFIGURED_ARCH }}/golang-1.15-go_1.15.15-1~deb11u4%2Bfips_{{ CONFIGURED_ARCH }}.deb' \
 && wget -O golang-src.deb 'https://sonicstorage.blob.core.windows.net/public/fips/bullseye/0.1/{{ CONFIGURED_ARCH }}/golang-1.15-src_1.15.15-1~deb11u4%2Bfips_{{ CONFIGURED_ARCH }}.deb' \
 && dpkg -i golang-go.deb golang-src.deb \
 && ln -sf /usr/lib/go-1.15 /usr/local/go \
 && rm golang-go.deb golang-src.deb
{%- endif %}

RUN pip3 install --no-cache-dir --upgrade pip
RUN apt-get purge -y python3-pip python3-yaml

# For building Python packages
RUN pip3 install --no-cache-dir setuptools==49.6.00
RUN pip3 install --no-cache-dir wheel==0.35.1

# For building sonic-utilities
RUN pip3 install --no-cache-dir fastentrypoints mock

# For running Python unit tests
RUN pip3 install --no-cache-dir pytest-runner==5.2
RUN pip3 install --no-cache-dir nose==1.3.7
RUN pip3 install --no-cache-dir mockredispy==2.9.3

# For p4 build
RUN pip3 install --no-cache-dir \
         ctypesgen==1.0.2 \
         crc16

# For sonic config engine testing
# Install pyangbind here, outside sonic-config-engine dependencies, as pyangbind causes enum34 to be installed.
# enum34 causes Python 're' package to not work properly as it redefines an incompatible enum.py module
# https://github.com/robshakir/pyangbind/issues/232
RUN pip3 install --no-cache-dir pyangbind==0.8.1
RUN pip3 uninstall -y enum34

# For templating
RUN pip3 install --no-cache-dir j2cli==0.3.10

# For sonic-mgmt-framework
RUN pip3 install --no-cache-dir "PyYAML==5.4.1"
RUN pip3 install --no-cache-dir "lxml==4.6.2"

# For sonic-platform-common testing
RUN pip3 install --no-cache-dir redis

# For vs image build
RUN pip3 install --no-cache-dir pexpect==4.8.0

# For sonic-swss-common testing
RUN pip3 install --no-cache-dir Pympler==0.8

# For sonic_yang_model build
RUN pip3 install --no-cache-dir pyang==2.4.0

# For mgmt-framework build
RUN pip3 install --no-cache-dir mmh3==2.5.1

RUN pip3 install --no-cache-dir parameterized==0.8.1

RUN apt-get install --no-install-recommends -y xsltproc && rm -rf /var/lib/apt/lists/*;

# Install dependencies for isc-dhcp-relay build
RUN apt-get -y build-dep isc-dhcp

# Install vim
RUN apt-get install --no-install-recommends -y vim && rm -rf /var/lib/apt/lists/*;

# Install rsyslog
RUN apt-get install --no-install-recommends -y rsyslog && rm -rf /var/lib/apt/lists/*;

RUN cd /usr/src/gtest && cmake . && make -C /usr/src/gtest

RUN mkdir /var/run/sshd
EXPOSE 22

# Install depot-tools (for git-retry)
RUN git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git /usr/share/depot_tools
ENV PATH /usr/share/depot_tools:$PATH

# Install dependencies for dhcp relay test
RUN pip3 install --no-cache-dir parameterized==0.8.1
RUN pip3 install --no-cache-dir pyfakefs

# Install docker engine 20.10 inside docker and enable experimental feature
RUN apt-get update
RUN apt-get install --no-install-recommends -y \
           apt-transport-https \
           ca-certificates \
           curl \
           gnupg2 \
           software-properties-common && rm -rf /var/lib/apt/lists/*;
{%- if CONFIGURED_ARCH == "armhf" %}
    RUN update-ca-certificates --fresh
{%- endif %}
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
RUN add-apt-repository \
           "deb [arch={{ CONFIGURED_ARCH }}] https://download.docker.com/linux/debian \
           $(lsb_release -cs) \
           stable"
RUN apt-get update
RUN apt-get install --no-install-recommends -y docker-ce=5:20.10.14~3-0~debian-bullseye docker-ce-cli=5:20.10.14~3-0~debian-bullseye containerd.io=1.5.11-1 && rm -rf /var/lib/apt/lists/*;
RUN echo "DOCKER_OPTS=\"--experimental --storage-driver=vfs {{ DOCKER_EXTRA_OPTS }}\"" >> /etc/default/docker
RUN update-alternatives --set iptables /usr/sbin/iptables-legacy

# Install m2crypto package, needed by SWI tools
RUN pip3 install --no-cache-dir m2crypto==0.36.0

# Install swi tools
RUN pip3 install --no-cache-dir git+https://github.com/aristanetworks/swi-tools.git@bead66bf261770237f7dd21ace3774ba04a017e9

{% if CONFIGURED_ARCH != "amd64" -%}
# Install node.js for azure pipeline
RUN curl -f -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# Tell azure pipeline to use node.js in the docker
LABEL "com.azure.dev.pipelines.agent.handler.node.path"="/usr/bin/node"
{% endif -%}

# Install Bazel build system (amd64 and arm64 architectures are supported using this method)
# TODO(PINS): Remove once pre-build Bazel binaries are available for armhf (armv7l)
{%- if CONFIGURED_ARCH == "amd64" or CONFIGURED_ARCH == "arm64" %}
ARG bazelisk_url=https://github.com/bazelbuild/bazelisk/releases/latest/download/bazelisk-linux-{{ CONFIGURED_ARCH }}
RUN curl -fsSL -o /usr/local/bin/bazel ${bazelisk_url} && chmod 755 /usr/local/bin/bazel
# Bazel requires "python"
# TODO(PINS): remove when Bazel is okay with "python3" binary name
RUN apt install --no-install-recommends -y python-is-python3 && rm -rf /var/lib/apt/lists/*;
{% endif -%}
