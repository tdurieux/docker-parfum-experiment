FROM centos:8

RUN [[ centos != centos ]] || [[ 8 != 8 ]] || ( \
    cd /etc/yum.repos.d/ && sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* \
    && sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.epel.cloud|g' /etc/yum.repos.d/CentOS-* \
    )

RUN yum -y update

# FIXME: Hack around docker/docker#10180
RUN ( yum install -y yum-plugin-ovl || yum install -y yum-plugin-ovl || touch /var/lib/rpm/* ) \
    && yum clean all && rm -rf /var/cache/yum

# Enable some other repos for some dependencies in OL/7
# see https://yum.oracle.com/getting-started.html#installing-from-oracle-linux-yum-server
RUN [[ centos != oraclelinux ]] || [[ 8 != 7 ]] || ( \
       yum install -y oraclelinux-release-el7 oracle-softwarecollection-release-el7 oracle-epel-release-el7  oraclelinux-developer-release-el7 \
       && yum-config-manager --enable \
            ol7_software_collections \
            ol7_developer \
            ol7_developer_EPEL \
            ol7_optional_latest \
            ol7_optional_archive \
            ol7_u9_base \
            ol7_security_validation \
            ol7_addons \
         ) && rm -rf /var/cache/yum

# lz4 1.8 is preloaded in oracle 7 however, lz4-devel is not loaded and only 1.7.5 version exists
# in oracle 7 repos. So package from centos repo was used
# There is no package in oracle repos for lz4. Also it is not preloaded. So both lz4 and lz4-devel packages
# were downloaded from centos el/6 repos
RUN if [[ centos   == oraclelinux ]] && [[ 8 == 7 ]]; then \
 yum install -y wget \
        && wget https://mirror.centos.org/centos/7/os/x86_64/Packages/lz4-devel-1.8.3-1.el7.x86_64.rpm \
        && rpm -ivh lz4-devel-1.8.3-1.el7.x86_64.rpm; rm -rf /var/cache/yum \
        elif [[ centos   == oraclelinux ]] && [[ 8 == 6 ]]; then \
        yum install -y wget \
        && wget https://cbs.centos.org/kojifiles/packages/lz4/r131/1.el6/x86_64/lz4-r131-1.el6.x86_64.rpm \
        && rpm -ivh lz4-r131-1.el6.x86_64.rpm \
        && wget https://cbs.centos.org/kojifiles/packages/lz4/r131/1.el6/x86_64/lz4-devel-r131-1.el6.x86_64.rpm \
        && rpm -ivh lz4-devel-r131-1.el6.x86_64.rpm; rm -rf /var/cache/yum \
        else yum install -y lz4 lz4-devel; rm -rf /var/cache/yumfi


# install build tools and PostgreSQL development files
RUN ( yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm \
    && [[ -z "epel-release" ]] || yum install -y epel-release) \
    && yum groupinstall -y 'Development Tools' \
    && yum install -y \
        curl \
        flex \
        gcc-c++ \
        hunspell-en \
        libcurl-devel \
        libicu-devel \
        libstdc++-devel \
        libxml2-devel \
        libxslt-devel \
        openssl-devel \
        pam-devel \
        readline-devel \
        rpm-build \
        rpmlint \
        spectool \
        tar \
        libzstd \
        libzstd-devel \
        llvm-toolset ccache \
    && ( [[ 8 < 8 ]] || dnf -qy module disable postgresql ) \
    && yum install -y postgresql13-server postgresql13-devel \
    && yum clean all && rm -rf /var/cache/yum

# install jq to process JSON API responses
RUN curl -f -sL https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 \
         -o /usr/bin/jq \
    && chmod +x /usr/bin/jq

# install devtoolset-8-gcc on distros where it is available
RUN { \
        { yum search devtoolset-8-gcc 2>&1 | grep 'No matches found' ; } \
        || yum install -y devtoolset-8-gcc devtoolset-8-libstdc++-devel; \
    } \
    && yum clean all && rm -rf /var/cache/yum

# install sphinx on distros with python3
RUN { \
        { yum search python3-pip 2>&1 | grep 'No matches found' ; } \
        || { \
         yum install -y python3-pip && \
            pip3 install --no-cache-dir sphinx==1.8 \
            ; \
           } \
          } \
    && yum clean all && rm -rf /var/cache/yum


RUN touch /rpmlintrc \
    && echo '%_build_pkgcheck %{_bindir}/rpmlint -f /rpmlintrc' >> /etc/rpm/macros

# set PostgreSQL version, place scripts on path, and declare output volume
ENV PGVERSION=13 \
    PATH=/scripts:$PATH
COPY scripts /scripts
VOLUME /packages

ENTRYPOINT ["/scripts/fetch_and_build_rpm"]
