# Base Image
FROM xanderye/dnf-base:centos7-minimal

MAINTAINER XanderYe

# 定义默认环境变量
ENV AUTO_MYSQL_IP=true
ENV MYSQL_NAME=dnfmysql
ENV MYSQL_IP=192.168.1.2
ENV MYSQL_PORT=3306
ENV GAME_PASSWORD=uu5!^%jg
ENV AUTO_PUBLIC_IP=false
ENV PUBLIC_IP=127.0.0.1
ENV DP2=false
ENV GM_ACCOUNT=gm_user
ENV GM_PASSWORD=123456
ENV GM_CONNECT_KEY=763WXRBW3PFTC3IXPFWH
ENV GM_LANDER_VERSION=20180307

# 将模板添加到模版目录下[后续容器启动需要先将环境变量替换,再将文件移动到正确位置]
ADD neople /home/template/neople
ADD root /home/template/root
ADD init /home/template/init
ADD dp2.tar.gz /
ADD TeaEncrypt /
# 启动脚本
ADD docker-entrypoint.sh /

RUN chmod -R 777 /tmp && mkdir /data && chmod +x /TeaEncrypt

# 切换工作目录