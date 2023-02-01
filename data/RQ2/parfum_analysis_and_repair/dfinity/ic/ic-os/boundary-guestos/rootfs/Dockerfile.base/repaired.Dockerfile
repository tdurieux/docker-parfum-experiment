# Boundary Guestos - Base Image
#
# Build steps:
# - `docker build -t dfinity/boundaryos-base:<tag> -f Dockerfile.base .`
# - `docker push/pull dfinity/boundaryos-base:<tag>`
# - `docker build -t dfinity/boundaryos-base-snp:<tag> --build-arg CPU_SUPPORT="snp" -f Dockerfile.base
# - `docker push/pull dfinity/boundaryos-base-snp:<tag>`

# NOTE! If you edit this file, you will need to perform the following
# operations to get your changes deployed.
#
# 1. Get your MR approved and merged into master
# 2. On the next hourly master pipeline (Run post-merge tests), click the "deploy-guest-os-baseimg" job
# 3. Note the sha256 and update the sha256 reference in the neighboring Dockerfiles.

# AMD SEV-SNP support version and sha256
ARG snp_tag=sev-snp-release-2022-06-01
ARG snp_sha=d61ed4419c2e98925e28ccc6e55dbb0b2c5d4b1c
ARG snp_kernel_version=5.17.0-rc6-snp-guest-dfa5ba8348e4
ARG snp_kernel_pkg=linux-image-${snp_kernel_version}_${snp_kernel_version}-1_amd64.deb

# Service worker verion and sha256
ARG sw_version=1.2.0
ARG sw_sha256=2f84ab0b02e3ac45b2c4de31789ccf7f6389887931970326842bfefb07073b55

#
# First build stage: download software, build and verify it (such that it
# does not change under our noses).
#
FROM ubuntu:20.04 AS download

ENV TZ=UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get -y update && apt-get -y upgrade && apt-get -y --no-install-recommends install \
    ca-certificates \
    curl \
    pkg-config \
    libffi-dev \
    libssl-dev \
    ssl-cert \
    rustc \
    cargo \
    perl && rm -rf /var/lib/apt/lists/*;

WORKDIR /tmp

# Download SNP support
ARG snp_tag
ARG snp_sha
ARG snp_kernel_pkg
RUN curl -f -L -O https://github.com/dfinity/AMDSEV/releases/download/${snp_tag}/${snp_kernel_pkg} && \
    echo "${snp_sha}  ${snp_kernel_pkg}" | shasum -c

# Download and verify journalbeat
RUN \
    curl -f -L -O https://artifacts.elastic.co/downloads/beats/journalbeat/journalbeat-oss-7.14.0-linux-x86_64.tar.gz && \
    echo "3c97e8706bd0d2e30678beee7537b6fe6807cf858a0dd2e7cfce5beccb621eb0fefe6871027bc7b55e2ea98d7fe2ca03d4d92a7b264abbb0d6d54ecfa6f6a305  journalbeat-oss-7.14.0-linux-x86_64.tar.gz" | shasum -c

# Download and verify vector
RUN \
    curl -f -L -O https://packages.timber.io/vector/0.21.0/vector_0.21.0-1_amd64.deb && \
    echo "bd713a9e739cca53f9aa1e49e4abf0f0a3ba68a1c5f5f42106ed9b98282f2f06f009e0779c24368aea9d4e829af7614043ae9625dcc849717931c20a6812ede7  vector_0.21.0-1_amd64.deb" | shasum -c

# Download and verify node_exporter
RUN \
    curl -f -L -O https://github.com/prometheus/node_exporter/releases/download/v1.3.1/node_exporter-1.3.1.linux-amd64.tar.gz && \
    echo "68f3802c2dd3980667e4ba65ea2e1fb03f4a4ba026cca375f15a0390ff850949  node_exporter-1.3.1.linux-amd64.tar.gz" | shasum -c

# Download and verify nginx_exporter
RUN \
    curl -f -L -O https://github.com/nginxinc/nginx-prometheus-exporter/releases/download/v0.10.0/nginx-prometheus-exporter_0.10.0_linux_amd64.tar.gz && \
    echo "30e664006dbc2d1185d3a5445942cd8158d1bb58  nginx-prometheus-exporter_0.10.0_linux_amd64.tar.gz" | shasum -c

# Download libnginx-mod-http-ndk.deb
RUN \
   curl -f -L -O https://github.com/dfinity/nginx-module-cbor-input/releases/download/v0.0.9/libnginx-mod-http-ndk_0.3.1_amd64.deb && \
   echo "6a496d8c7f3357fda9e5adeb7a729e76c453f32c6d67bc0ec563b0f71e2a0aca  libnginx-mod-http-ndk_0.3.1_amd64.deb" | shasum -c

# Download libnginx-mod-http-cbor-input.deb
RUN \
   curl -f -L -O https://github.com/dfinity/nginx-module-cbor-input/releases/download/v0.0.9/libnginx-mod-http-cbor-input_0.0.9_amd64.deb && \
   echo "8dca8fb93a6645c4aee23f601e9d9f62a00638ff29f95ceafcd10f422a3126f0  libnginx-mod-http-cbor-input_0.0.9_amd64.deb" | shasum -c

# Download icx-proxy.deb
RUN \
    curl -f -L -O https://github.com/dfinity/icx-proxy/releases/download/rev-dcaa135/icx-proxy.deb && \
    echo "e20c7f6dcbe438ef9ec7dbff7d88d88db4099cb2b8d6dc399f47856baf0e568c  icx-proxy.deb" | shasum -c

# Download and check service worker
ARG sw_version
ARG sw_sha256
RUN \
   curl -f -L -O https://registry.npmjs.org/@dfinity/service-worker/-/service-worker-${sw_version}.tgz && \
   echo "${sw_sha256}  service-worker-${sw_version}.tgz" | shasum -c

#
# Second build stage:
# - Download and cache minimal Ubuntu Server 20.04 LTS Docker image
# - Install and cache upstream packages from built-in Ubuntu repositories
# - Copy downloaded archives from first build stage into the target image
#
FROM ubuntu:20.04

ENV TZ=UTC
ENV SOURCE_DATE_EPOCH=0

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Preparation and install of packages for nginx
RUN apt-get -y update && apt-get -y upgrade && apt-get -y --no-install-recommends install gnupg && rm -rf /var/lib/apt/lists/*;
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ABF5BD827BD9BF62

RUN echo "deb http://nginx.org/packages/mainline/ubuntu/ focal nginx" >> /etc/apt/sources.list.d/nginx.list &&\
    echo "deb-src http://nginx.org/packages/mainline/ubuntu/ focal nginx" >> /etc/apt/sources.list.d/nginx.list

RUN apt-get -y update && apt-get -y upgrade && apt-get -y --no-install-recommends install \
    attr \
    ca-certificates \
    checkpolicy \
    chrony \
    cryptsetup \
    curl \
    dante-server \
    faketime \
    fdisk \
    haveged \
    initramfs-tools \
    inotify-tools \
    iproute2 \
    iputils-ping \
    isc-dhcp-client \
    less \
    libffi-dev \
    liblmdb0 \
    libssl-dev \
    linux-image-virtual-hwe-20.04 \
    logrotate \
    lshw \
    lvm2 \
    net-tools \
    nftables \
    nginx-module-njs=1.21.3+0.7.0-1~focal \
    nginx=1.21.3-1~focal \
    opensc \
    openssh-client openssh-server \
    parted \
    pciutils \
    pcsc-tools pcscd \
    policycoreutils \
    python \
    python3-dev \
    rsync \
    ssl-cert \
    stunnel \
    sudo \
    systemd systemd-sysv systemd-journal-remote \
    udev \
    usbutils \
    vim \
    zstd && rm -rf /var/lib/apt/lists/*;

# For the common image, just use common to use the default kernel of Ubuntu
# For the SEV-SNP image, use "snp"  -- this can
# be set via docker build args (see above).
ARG CPU_SUPPORT=common

# Copy AMD SEV-SNP kernel support
ARG snp_tag
ARG snp_kernel_pkg
COPY --from=download /tmp/${snp_kernel_pkg} /tmp/${snp_kernel_pkg}

# Install AMD SEV-SNP kernel support
ARG CPU_SUPPORT
ARG snp_tag
ARG snp_kernel_version
ARG snp_kernel_pkg
RUN \
    echo "CPU_SUPPORT: ${CPU_SUPPORT}" && \
    if [ "${CPU_SUPPORT}" = "snp" ] ; then \
		dpkg -i /tmp/${snp_kernel_pkg} && \
		# Create initrd for the new kernel
		update-initramfs -b /boot -c -k ${snp_kernel_version} && \
		# Create soft link for vmlinuz and initrd.img pointing to the updated images
		unlink /boot/vmlinuz && \
		unlink /boot/initrd.img && \
		ln -s /boot/vmlinuz-${snp_kernel_version}/boot/vmlinuz && \
		ln -s /boot/initrd.img-${snp_kernel_version}/boot/initrd.img ; \
     fi

# Cleanup
RUN rm /tmp/${snp_kernel_pkg}

# Install journalbeat
COPY --from=download /tmp/journalbeat-oss-7.14.0-linux-x86_64.tar.gz /tmp/journalbeat-oss-7.14.0-linux-x86_64.tar.gz
RUN cd /tmp/ && \
    mkdir -p /etc/journalbeat \
             /var/lib/journalbeat \
             /var/log/journalbeat && \
    tar --strip-components=1 -C /etc/journalbeat/ -zvxf journalbeat-oss-7.14.0-linux-x86_64.tar.gz journalbeat-7.14.0-linux-x86_64/fields.yml && \
    tar --strip-components=1 -C /etc/journalbeat/ -zvxf journalbeat-oss-7.14.0-linux-x86_64.tar.gz journalbeat-7.14.0-linux-x86_64/journalbeat.reference.yml && \
    tar --strip-components=1 -C /usr/local/bin/ -zvxf journalbeat-oss-7.14.0-linux-x86_64.tar.gz journalbeat-7.14.0-linux-x86_64/journalbeat && \
    rm /tmp/journalbeat-oss-7.14.0-linux-x86_64.tar.gz

# Install vector
COPY --from=download /tmp/vector_0.21.0-1_amd64.deb /tmp/vector_0.21.0-1_amd64.deb
RUN dpkg -i --force-confold /tmp/vector_0.21.0-1_amd64.deb && \
    rm /tmp/vector_0.21.0-1_amd64.deb

# Install node_exporter
COPY --from=download /tmp/node_exporter-1.3.1.linux-amd64.tar.gz /tmp/node_exporter-1.3.1.linux-amd64.tar.gz
RUN cd /tmp/ && \
    mkdir -p /etc/node_exporter && \
    tar --strip-components=1 -C /usr/local/bin/ -zvxf node_exporter-1.3.1.linux-amd64.tar.gz node_exporter-1.3.1.linux-amd64/node_exporter && \
    rm /tmp/node_exporter-1.3.1.linux-amd64.tar.gz

COPY --from=download /tmp/nginx-prometheus-exporter_0.10.0_linux_amd64.tar.gz /tmp/nginx-prometheus-exporter_0.10.0_linux_amd64.tar.gz
RUN \
    tar \
        -C /usr/local/bin \
        -zvxf /tmp/nginx-prometheus-exporter_0.10.0_linux_amd64.tar.gz \
        nginx-prometheus-exporter && \
    mv \
        /usr/local/bin/nginx-prometheus-exporter \
        /usr/local/bin/nginx_exporter && \
    rm /tmp/nginx-prometheus-exporter_0.10.0_linux_amd64.tar.gz

# Install libnginx-mod-http-ndk
COPY --from=download /tmp/libnginx-mod-http-ndk_0.3.1_amd64.deb /tmp/
RUN dpkg -i /tmp/libnginx-mod-http-ndk_0.3.1_amd64.deb &&\
    rm /tmp/libnginx-mod-http-ndk_0.3.1_amd64.deb

# Install libnginx-mod-http-cbor-input
COPY --from=download /tmp/libnginx-mod-http-cbor-input_0.0.9_amd64.deb /tmp/libnginx-mod-http-cbor-input_0.0.9_amd64.deb
RUN dpkg -i /tmp/libnginx-mod-http-cbor-input_0.0.9_amd64.deb &&\
    rm /tmp/libnginx-mod-http-cbor-input_0.0.9_amd64.deb

# Install icx-proxy
COPY --from=download /tmp/icx-proxy.deb /tmp/icx-proxy.deb
RUN dpkg -i /tmp/icx-proxy.deb &&\
    rm /tmp/icx-proxy.deb

# Install ic service worker production version from: https://registry.npmjs.org/@dfinity/service-worker/-/
ARG sw_version
COPY --from=download /tmp/service-worker-${sw_version}.tgz /tmp/service-worker-${sw_version}.tgz
RUN cd /tmp && tar xfvz service-worker-${sw_version}.tgz && \
    mkdir -p /var/www/html/ &&\
    cp -rf /tmp/package/dist-prod/* /var/www/html/ &&\
    rm -rf /tmp/package /tmp/service-worker-${sw_version}.tgz
