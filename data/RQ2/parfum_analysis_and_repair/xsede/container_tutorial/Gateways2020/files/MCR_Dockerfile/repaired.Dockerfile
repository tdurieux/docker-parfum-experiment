FROM centos:7

RUN mkdir /opt/mcr                     && \
yum install wget unzip libXmu -y       && \
mkdir /mcr-install                     && \
cd /mcr-install                        && \
wget https://ssd.mathworks.com/supportfiles/downloads/R2018a/deployment_files/R2018a/installers/glnxa64/MCR_R2018a_glnxa64_installer.zip && \
unzip MCR_R2018a_glnxa64_installer.zip && \
./install -mode silent -agreeToLicense yes -destinationFolder /opt/mcr && \
rm -Rf /mcr-install && rm -rf /var/cache/yum

ENV LD_LIBRARY_PATH=/opt/mcr/v94/runtime/glnxa64:/opt/mcr/v94/bin/glnxa64:/opt/mcr/v94/sys/os/glnxa64:/opt/mcr/v94/extern/bin/glnxa64
ENV XAPPLRESDIR=/usr/share/X11/app-defaults

ADD mdimensionalArray /mdimensionalArray
RUN chmod +x mdimensionalArray
