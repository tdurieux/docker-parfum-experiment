FROM centos:8

LABEL \
	org.label-schema.schema-version = "1.0" \
	org.label-schema.name = "cricket" \
	org.label-schema.license = "MIT" \
	org.label-schema.vendor = "Institute for Automation of Complex Power Systems, RWTH Aachen University" \
	org.label-schema.author.name = "Niklas Eiling" \
	org.label-schema.author.email = "niklas.eiling@eonerc.rwth-aachen.de" \
	org.label-schema.vcs-url = "https://git.rwth-aachen.de/niklas.eiling/cricket"

RUN cd /etc/yum.repos.d/ && sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* && sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-* && yum update -y

RUN dnf -y update && \
    dnf install -y epel-release dnf-plugins-core && \
    dnf install -y https://rpms.remirepo.net/enterprise/remi-release-8.rpm && \
    dnf config-manager --set-enabled powertools && \
    dnf config-manager --set-enabled remi

RUN dnf install -y make bash git gcc autoconf libtool automake rpcgen \
                   ncurses-devel zlib-devel binutils-devel mesa-libGL-devel \
                   libvdpau-devel mesa-libEGL-devel openssl-devel rpcbind \
                   texinfo bison flex python3 which libibverbs libibverbs-devel \
                   libasan cppcheck wget expat-devel xz-devel mesa-libGLU-devel freeglut-devel

ENV LD_LIBRARY_PATH="/usr/local/lib:/usr/local/lib64:${LD_LIBRARY_PATH}"

RUN dnf -y config-manager --add-repo http://developer.download.nvidia.com/compute/cuda/repos/rhel8/x86_64/cuda-rhel8.repo && \
    dnf --refresh -y install cuda-compiler-11-1 cuda-libraries-devel-11-1 cuda-samples-11-1 cuda-driver-devel-11-1 && \
    ln -s cuda-11.1 /usr/local/cuda && \
    ln -s libcuda.so /usr/local/cuda/targets/x86_64-linux/lib/stubs/libcuda.so.1

ENV PATH="/usr/local/cuda/bin:${PATH}"
ENV LIBRARY_PATH="/usr/local/cuda/targets/x86_64-linux/lib/stubs:$(LIBRARY_PATH}"
ENV LD_LIBRARY_PATH="/usr/local/cuda/lib64:/usr/local/cuda/targets/x86_64-linux/lib/stubs:${LD_LIBRARY_PATH}"

#COPY --chown=root .ssh /root/.ssh

WORKDIR /cricket

ENTRYPOINT /bin/bash

