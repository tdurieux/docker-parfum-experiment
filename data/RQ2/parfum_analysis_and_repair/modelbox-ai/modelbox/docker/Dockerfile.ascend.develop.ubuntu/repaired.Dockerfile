FROM modelbox/ascend-base-ubuntu:latest
FROM ubuntu:18.04

COPY release /opt/release
COPY --from=0 /usr/local/Ascend_dev /usr/local/Ascend

ADD *.tar.gz /usr/local/

ARG ASCEND_PATH=/usr/local/Ascend
ENV LOCAL_ASCEND=/usr/local/Ascend
ENV ASCEND_AICPU_PATH=${ASCEND_PATH}/ascend-toolkit/latest
ENV ASCEND_OPP_PATH=${ASCEND_PATH}/ascend-toolkit/latest/opp
ENV TOOLCHAIN_HOME=${ASCEND_PATH}/ascend-toolkit/latest/toolkit
ENV TBE_IMPL_PATH=${ASCEND_PATH}/ascend-toolkit/latest/opp/op_impl/build-in/ai_core/tbe
ENV MINDSPORE_PATH=/usr/local/lib/python3.7/dist-packages/mindspore
ENV DDK_PATH=${ASCEND_PATH}/ascend-toolkit/latest/fwkacllib
ENV DRIVER_PATH=${ASCEND_PATH}/driver

ENV PATH=\
${ASCEND_PATH}/ascend-toolkit/latest/atc/bin:\
${ASCEND_PATH}/ascend-toolkit/latest/fwkacllib/bin:\
${ASCEND_PATH}/ascend-toolkit/latest/fwkacllib/ccec_compiler/bin:\
${ASCEND_PATH}/ascend-toolkit/latest/atc/ccec_compiler/bin${PATH:+:${PATH}}

ENV PYTHONPATH=\
${ASCEND_PATH}/ascend-toolkit/latest/atc/python/site-packages:\
${ASCEND_PATH}/ascend-toolkit/latest/toolkit/python/site-packages:\
${ASCEND_PATH}/ascend-toolkit/latest/fwkacllib/python/site-packages:\
${ASCEND_PATH}/ascend-toolkit/latest/opp/op_impl/build-in/ai_core/tbe:\
${ASCEND_PATH}/ascend-toolkit/latest/pyACL/python/site-packages/acl${PYTHONPATH:+:${PYTHONPATH}}

ENV LD_LIBRARY_PATH=${ASCEND_PATH}/ascend-toolkit/latest/fwkacllib/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

WORKDIR /root

RUN ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo "Asia/Shanghai" > /etc/timezone && \
    if [ "$(arch)" = "aarch64" ];then sed -i 's@ports.ubuntu.com@mirrors.ustc.edu.cn@g' /etc/apt/sources.list;fi && \
    rm -rf /var/lib/dpkg/info/* && \
    apt update && apt upgrade -y && \
    apt install --no-install-recommends -y python3.7-dev python3-pip python3-apt python3-setuptools apt-utils && \
    apt install --no-install-recommends -y \
        dbus systemd systemd-cron iproute2 gnupg2 curl libcurl4-openssl-dev ca-certificates \
        build-essential unzip ffmpeg sudo bash vim gdb git doxygen autoconf cmake gettext openssh-server \
        python3-wheel python3-numpy python3-opencv libopencv-dev pkg-config kmod net-tools pciutils \
        libssl-dev libcpprest-dev libswscale-dev libavformat-dev graphviz libgraphviz-dev libfuse-dev \
        libprotobuf-c-dev protobuf-c-compiler duktape-dev libopenblas-dev netcat && \
    rm -f /usr/bin/python3 /usr/bin/python && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3.7 100 && \
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.7 100 && \
    update-alternatives --config python3 && \
    rm -rf /var/lib/apt/lists/* /root/*

RUN mkdir -p /root/.pip && \
    echo "[global]" > /root/.pip/pip.conf && \
    echo "index-url = https://pypi.python.org/simple" >>/root/.pip/pip.conf && \
    echo "trusted-host = pypi.python.org" >>/root/.pip/pip.conf && \
    echo "timeout = 120" >>/root/.pip/pip.conf && \
    if [ "$(arch)" = "aarch64" ];then sed -i 's@python.org@douban.com@g' /root/.pip/pip.conf;fi && \
    groupadd HwHiAiUser && \
    useradd -g HwHiAiUser -d /home/HwHiAiUser -m HwHiAiUser && \
    python3 -m pip install --upgrade pip && \
    python3 -m pip install --no-cache-dir wheel attrs psutil decorator protobuf scipy sympy cffi grpcio grpcio-tools requests pillow pyyaml opencv-python && \
    python3 -m pip install --no-cache-dir https://ms-release.obs.cn-north-4.myhuaweicloud.com/1.6.1/MindSpore/ascend/$(arch)/mindspore_ascend-1.6.1-cp37-cp37m-linux_$(arch).whl && \
    python3 -m pip install --no-cache-dir ${ASCEND_PATH}/ascend-toolkit/latest/fwkacllib/lib64/topi-0.4.0-py3-none-any.whl && \
    python3 -m pip install --no-cache-dir ${ASCEND_PATH}/ascend-toolkit/latest/fwkacllib/lib64/te-0.4.0-py3-none-any.whl && \
    python3 -m pip install --no-cache-dir ${ASCEND_PATH}/ascend-toolkit/latest/fwkacllib/lib64/hccl-0.1.0-py3-none-any.whl && \
    echo "/usr/local/lib" >>  /etc/ld.so.conf && \
    echo "${ASCEND_PATH}/driver/lib64" >>/etc/ld.so.conf && \
    echo "${ASCEND_PATH}/ascend-toolkit/latest/fwkacllib/lib64" >>/etc/ld.so.conf

RUN if [ "$(arch)" = "aarch64" ];then node_arch="arm64";else node_arch="x64";fi && \
    curl -f https://nodejs.org/dist/v16.13.2/node-v16.13.2-linux-${node_arch}.tar.xz | tar -xJ && \
    cp -af node-v16.13.2-linux-${node_arch}/* /usr/local/ && \
    if [ "$(arch)" = "aarch64" ];then npm config set registry https://registry.npm.taobao.org/;fi && \
    npm install -g npm@latest && npm -v && node -v && \
    npm install -g @angular/cli && \
    npm cache clean --force && rm -rf /root/* && \
    python3 -m pip install --no-cache-dir /opt/release/python/modelbox-*.whl && \
    dpkg -i /opt/release/*.deb && \
    usermod -G HwHiAiUser modelbox

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; \
    do [ $i = systemd-tmpfiles-setup.service ] || rm -f $i; done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*; \
    rm -f /etc/systemd/system/*.wants/*; \
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*; \
    rm -f /lib/systemd/system/anaconda.target.wants/*; \
    sed -i "32aPermitRootLogin yes" /etc/ssh/sshd_config && \
    sed -i 's/^SystemMaxUse=.*/SystemMaxUse=16M/g' /etc/systemd/journald.conf && \
    echo 'export TMOUT=0' >> ~/.bashrc && \
    echo 'export HISTSIZE=1000' >> ~/.bashrc && \
    echo '[ -n "${SSH_TTY}" ] && export $(cat /proc/1/environ|tr "\\0" "\\n"|xargs)' >> /etc/bash.bashrc && \
    echo 'export PS1="\[\e[35;1m\][\u@\h \W]$ \[\e[0m\]"' >> ~/.bashrc && \
    ldconfig -v 2>/dev/null|grep "libascend_hal.so" && systemctl enable ssh

VOLUME ["/sys/fs/cgroup", "/tmp", "/run", "/run/lock"]
STOPSIGNAL SIGRTMIN+3

CMD ["/sbin/init", "--log-target=journal"]
