#FROM rayproject/ray:nightly
FROM ccr.ccs.tencentyun.com/cube-studio/ray:nightly
USER root
# 安装调试相关工具
RUN apt update && apt install -y --force-yes --no-install-recommends vim apt-transport-https gnupg2 ca-certificates-java rsync jq  wget git dnsutils iputils-ping net-tools curl mysql-client locales zip software-properties-common && rm -rf /var/lib/apt/lists/*;

ENV TZ 'Asia/Shanghai'
ENV DEBIAN_FRONTEND=noninteractive

# 安装开发相关工具
RUN apt install --no-install-recommends -y python3-dev gcc automake autoconf libtool make ffmpeg build-essential && rm -rf /var/lib/apt/lists/*;

# 安装pip库
RUN pip install --no-cache-dir pysnooper cython

ENV RAY_CLIENT_SERVER_MAX_THREADS=1000

# 安装当前代码
USER root
COPY job/video-audio /app
COPY job/pkgs /app/job/pkgs
# COPY job/pkgs/config/pip.conf /root/.pip/pip.conf
# COPY job/pkgs/config/ubuntu-sources.list /etc/apt/sources.list

WORKDIR /app
ENTRYPOINT ["python", "start_download.py"]


