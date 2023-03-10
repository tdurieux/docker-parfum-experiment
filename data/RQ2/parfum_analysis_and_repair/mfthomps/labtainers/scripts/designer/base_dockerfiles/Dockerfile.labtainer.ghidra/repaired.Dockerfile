ARG registry
FROM $registry/labtainer.centos.xtra
LABEL description="This is base Docker image for Labtainer Ghidra containers"
RUN yum install -y unzip && rm -rf /var/cache/yum
RUN mkdir /ghidra
RUN cd /ghidra
ADD zip/ghidra_9.1.1_PUBLIC_20191218.zip /var/tmp
RUN /usr/bin/unzip /var/tmp/ghidra*zip
ADD zip/OpenJDK11U-jdk_*.tar.gz /ghidra/
ADD zip/OpenJDK11U-jre_*.tar.gz /ghidra/
ADD zip/amazon*.tar.gz /ghidra/
RUN yum install -y libXtst && rm -rf /var/cache/yum
RUN sed -i 's/ bg / fg /' /ghidra_9.1.1_PUBLIC/ghidraRun
RUN sed -i '/SCRIPT_DIR=/a export PATH=/ghidra/jdk-11.0.6+10/bin:$PATH' /ghidra_9.1.1_PUBLIC/ghidraRun
