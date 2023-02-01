#FROM rayproject/ray:nightly
FROM ccr.ccs.tencentyun.com/cube-studio/ray:nightly
USER root

COPY job/pkgs/config/pip.conf /root/.pip/pip.conf
COPY job/pkgs/config/ubuntu-sources.list /etc/apt/sources.list

# 安装调试相关工具
RUN apt update && apt install -y --force-yes --no-install-recommends vim apt-transport-https gnupg2 ca-certificates-java rsync jq  wget git dnsutils iputils-ping net-tools curl mysql-client locales zip software-properties-common && rm -rf /var/lib/apt/lists/*;

ENV TZ 'Asia/Shanghai'
ENV DEBIAN_FRONTEND=noninteractive

# 安装开发相关工具
RUN apt install --no-install-recommends -y python3-dev gcc automake autoconf libtool make ffmpeg build-essential && rm -rf /var/lib/apt/lists/*;

# 安装当前代码
USER root
COPY job/ray /app

WORKDIR /app
ENTRYPOINT ["bash", "/app/start.sh"]


