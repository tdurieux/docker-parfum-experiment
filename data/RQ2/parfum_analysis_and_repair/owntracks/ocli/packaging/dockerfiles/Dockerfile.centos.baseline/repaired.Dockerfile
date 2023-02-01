ARG BASE_IMAGE


# =========================
# Derive from superbaseline
# =========================
FROM ${BASE_IMAGE} AS centos-base

RUN yum install -y deltarpm; rm -rf /var/cache/yum exit 0
RUN yum update -y


# ===========
# Build tools
# ===========
FROM centos-base AS centos-build

# Build foundation and header files
RUN yum install -y \
    gcc gcc-c++ make pkgconfig && rm -rf /var/cache/yum


# ===============
# Packaging tools
# ===============
FROM centos-build AS centos-fpm

# FPM
RUN yum install -y \
    ruby ruby-devel rubygems rpm-build && rm -rf /var/cache/yum

RUN echo && echo "Installing fpm. This might take a while." && echo

# CentOS 6: Ruby is too old, so install "fpm" within "rvm" environment.
# https://github.com/jordansissel/fpm/issues/1192#issuecomment-466385257
RUN \
    grep 'release 6' /etc/centos-release || exit 0 && ( yum install -y curl libyaml && \
					curl -f -sSL https://rvm.io/pkuczynski.asc | gpg2 --import - && \
					curl -f -L get.rvm.io | bash -s stable && \
        # source /etc/profile.d/rvm.sh \
        export rvm=/usr/local/rvm/bin/rvm && \
					$rvm reload && \
					$rvm install 2.3.1 && \
					$rvm all do gem install fpm --version 1.11.0 && \
					ln -s /usr/local/rvm/gems/ruby-2.3.1/wrappers/fpm /usr/local/bin/fpm) && rm -rf /var/cache/yum

# CentOS 7,8
RUN \
    grep -v 'release 6' /etc/centos-release || exit 0 && ( \
        gem install fpm --version 1.11.0 \
    )


# =========================
# Prepare build environment
# =========================
FROM centos-fpm

RUN yum install -y openssl-devel libuuid-devel wget && rm -rf /var/cache/yum

# Install PUIAS and OKey repositories in order
# to install "scons" for building "gpsd".
RUN \
    grep 'release 6' /etc/centos-release || exit 0 && ( wget https://download-ib01.fedoraproject.org/pub/epel/6/x86_64/Packages/e/epel-release-6-8.noarch.rpm && \
        wget https://repo.okay.com.mx/centos/6/x86_64/release//okay-release-1-3.el6.noarch.rpm && \
        rpm -i *.rpm && \
        yum install -y python-devel scons) && rm -rf /var/cache/yum

RUN \
    grep 'release 7' /etc/centos-release || exit 0 && ( wget https://download-ib01.fedoraproject.org/pub/epel/7/x86_64/Packages/e/epel-release-7-12.noarch.rpm && \
        wget https://repo.okay.com.mx/centos/7/x86_64/release//okay-release-1-3.el7.noarch.rpm && \
        rpm -i *.rpm && \
        yum install -y python-devel scons) && rm -rf /var/cache/yum

RUN \
    grep 'release 8' /etc/centos-release || exit 0 && ( wget https://download-ib01.fedoraproject.org/pub/epel/8/Everything/x86_64/Packages/e/epel-release-8-8.el8.noarch.rpm && \
        wget https://repo.okay.com.mx/centos/8/x86_64/release//okay-release-1-3.el8.noarch.rpm && \
        rpm -i *.rpm && \
        yum install -y python3-devel scons) && rm -rf /var/cache/yum


# Install "gpsd".
RUN \
    wget https://gitlab.com/gpsd/gpsd/-/archive/release-3.19/gpsd-release-3.19.tar.gz && \
    tar -xzf gpsd-release-3.19.tar.gz && \
    cd gpsd-release-3.19 && \
    scons && scons install && rm gpsd-release-3.19.tar.gz

# Install "mosquitto".
RUN \
    wget https://mosquitto.org/files/source/mosquitto-1.5.9.tar.gz && \
    tar -xzf mosquitto-1.5.9.tar.gz && \
    cd mosquitto-1.5.9 && \
    make && make install && rm mosquitto-1.5.9.tar.gz
