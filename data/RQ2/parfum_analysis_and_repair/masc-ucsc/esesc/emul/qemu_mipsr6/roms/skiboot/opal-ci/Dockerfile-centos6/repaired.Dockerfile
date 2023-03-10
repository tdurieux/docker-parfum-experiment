FROM centos:6
RUN yum -y update && yum clean all
RUN yum -y install wget curl xterm gcc git xz ccache dtc openssl-devel && rm -rf /var/cache/yum
RUN wget https://www.kernel.org/pub/tools/crosstool/files/bin/x86_64/4.8.0/x86_64-gcc-4.8.0-nolibc_powerpc64-linux.tar.xz
RUN mkdir /opt/cross
RUN tar -C /opt/cross -xf x86_64-gcc-4.8.0-nolibc_powerpc64-linux.tar.xz && rm x86_64-gcc-4.8.0-nolibc_powerpc64-linux.tar.xz
RUN curl -f -O http://public.dhe.ibm.com/software/server/powerfuncsim/p8/packages/v1.0-2/systemsim-p8-1.0-2.el6.x86_64.rpm
RUN yum -y install systemsim-p8-1.0-2.el6.x86_64.rpm && rm -rf /var/cache/yum
COPY . /build/
WORKDIR /build
ENTRYPOINT ./opal-ci/build-centos6.sh
