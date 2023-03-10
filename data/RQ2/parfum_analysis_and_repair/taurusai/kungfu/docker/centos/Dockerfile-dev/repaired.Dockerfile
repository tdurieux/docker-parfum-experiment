FROM centos:7
RUN yum -y install git sudo rpm-build && yum -y install make && yum -y install centos-release-scl && \
    yum -y install devtoolset-8-gcc devtoolset-8-gcc-c++ devtoolset-8-binutils && \
    echo "source /opt/rh/devtoolset-8/enable" >> /etc/profile && echo "source /opt/rh/devtoolset-8/enable" >> ~/.bashrc && source ~/.bashrc && \
    yum -y install openssl-devel bzip2-devel libffi-devel sqlite-devel zlib-devel && \
    debuginfo-install -y glibc && \
    yum install -y rh-python36 && echo "source /opt/rh/rh-python36/enable" >> ~/.bashrc && source ~/.bashrc && \
    curl -f -sL https://rpm.nodesource.com/setup_10.x | bash - && yum -y install nodejs && \
    npm config set registry https://registry.npm.taobao.org && \
    npm config set puppeteer_download_host https://npm.taobao.org/mirrors && \
    npm config set electron_mirror https://npm.taobao.org/mirrors/electron/ && \
    npm config set sass-binary-site https://npm.taobao.org/mirrors/node-sass && \
    npm install -g yarn electron-builder && npm cache clean --force; && rm -rf /var/cache/yum

RUN yum install -y kde-l10n-Chinese && yum reinstall -y glibc-common && localedef -c -f GB18030 -i zh_CN zh_CN.GB18030 && rm -rf /var/cache/yum
RUN yum install -y http://repo.okay.com.mx/centos/7/x86_64/release/okay-release-1-1.noarch.rpm && yum -y install cmake3 && rm -rf /var/cache/yum
RUN pip3 install --no-cache-dir -i https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple/ pipenv

ENV PATH=/opt/rh/devtoolset-8/root/usr/bin/:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV LANG=en_US.UTF-8
ENV BASH_ENV=~/.bashrc  \
    ENV=~/.bashrc  \
    PROMPT_COMMAND="source ~/.bashrc"

