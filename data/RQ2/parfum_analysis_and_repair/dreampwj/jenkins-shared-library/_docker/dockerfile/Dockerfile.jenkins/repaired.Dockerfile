# Author: 潘维吉
# Version 1.0.0
# Description: 自定义定制jenkins镜像 满足特殊和定制化需求

FROM jenkins/jenkins:lts

USER root

RUN apt-get update \
      && apt-get install --no-install-recommends -y sudo \
      && rm -rf /var/lib/apt/lists/* \
      && apt-get install --no-install-recommends -y libtinfo5 && rm -rf /var/lib/apt/lists/*;
     # &&  apt-get install -y docker.io

RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers

USER jenkins

# 初始化所有配置的插件
COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt

# docker build -t my/jenkins:lts  -f /my/Dockerfile.jenkins . --no-cache
