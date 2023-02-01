FROM rustembedded/cross:x86_64-unknown-linux-gnu

RUN yum update -y && \
    yum install centos-release-scl -y && \
    yum install llvm-toolset-7 -y && \
    yum install scl-utils -y && \
    echo "source scl_source enable llvm-toolset-7" >> ~/.bash_profile && rm -rf /var/cache/yum
