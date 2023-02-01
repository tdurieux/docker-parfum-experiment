FROM centos:8

RUN dnf group install -y 'Development Tools' && \
    dnf --enablerepo=powertools install -y ocaml ocaml-ocamlbuild redhat-rpm-config openssl-devel wget rpm-build git cmake perl python2 libcurl-devel protobuf-devel && \
    alternatives --set python /usr/bin/python2

#ADD 01_gcc_8.sh /root
#RUN bash /root/01_gcc_8.sh

ENV BINUTILS_DIST="centos8"

ADD 02_binutils.sh /root
RUN bash /root/02_binutils.sh

ENV SDK_DIST="INTEL_BUILT"
ENV SDK_URL="https://download.01.org/intel-sgx/sgx-linux/2.17/distro/centos-stream/sgx_linux_x64_sdk_2.17.100.3.bin"
#ENV SDK_DIST="SELF_BUILT"
ADD 03_sdk.sh /root
RUN bash /root/03_sdk.sh

ENV PSW_REPO="https://download.01.org/intel-sgx/sgx-linux/2.17/distro/centos-stream/sgx_rpm_local_repo.tgz"
ADD 04_psw_rpm.sh /root
RUN bash /root/04_psw_rpm.sh

ENV rust_toolchain  nightly-2022-02-23
ADD 05_rust.sh /root
RUN bash /root/05_rust.sh

ENV rust_toolchain=
ENV CODENAME=
ENV VERSION=
ENV PSW_REPO=

WORKDIR /root