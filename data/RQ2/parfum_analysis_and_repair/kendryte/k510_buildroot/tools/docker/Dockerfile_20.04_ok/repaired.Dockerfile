FROM ubuntu:20.04
MAINTAINER k510_sdk
ARG USER_ID=1000
ARG NAME=ubuntu
ARG DIR=work
#ARG SOURCE=mirrors.aliyun.com
#ARG SOURCE=mirrors.cloud.tencent.com
ARG SOURCE=mirrors.tuna.tsinghua.edu.cn
ENV PATH=/home/${NAME}/.local/bin:$PATH
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true
#COPY get-pip.py  /
#COPY x86_64/nncase*  /

RUN sed -i s@/archive.ubuntu.com/@/${SOURCE}/@g /etc/apt/sources.list \
	&& sed -i s@/security.ubuntu.com/@/${SOURCE}/@g /etc/apt/sources.list   \
	&& echo 'root:123456' |chpasswd    \
	&& useradd -rm -d /home/${NAME} -s /bin/bash -g root -G sudo -u ${USER_ID} ${NAME} \
	&&mkdir -p  /home/${NAME}/${DIR}  && dpkg --add-architecture i386 \
	&& apt autoclean && apt-get update --fix-missing   \
	&& apt-get update && apt-get install --no-install-recommends -y --fix-missing net-tools inetutils-ping git git-lfs build-essential make wget cpio unzip rsync bc \
	libc6-dev-i386 libssl-dev libncurses5:i386 file python python3 python3-pip curl vim python-dev dosfstools mtools \
    qemu-system-misc qemu-user-static binfmt-support debootstrap debian-ports-archive-keyring mtd-utils && rm -rf /var/lib/apt/lists/*;
WORKDIR /home/${NAME}
USER ${NAME}
RUN pip3 install --no-cache-dir --upgrade pip -i https://mirrors.aliyun.com/pypi/simple/ \
		&& curl -f https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py && python2 get-pip.py && rm  -rf get-pip.py \
		&& pip3 install --no-cache-dir crypto pycrypto onnx==1.9.0 onnx-simplifier==0.3.6 onnxoptimizer==0.2.6 onnxruntime==1.8.0 -i https://mirrors.aliyun.com/pypi/simple/ \
		&& pip2 install --no-cache-dir pystache==0.5.4 pycrypto xlrd -i https://mirrors.aliyun.com/pypi/simple/
#RUN	 pip3 install /nncase*

#&& curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py \
CMD ["/bin/bash"]

