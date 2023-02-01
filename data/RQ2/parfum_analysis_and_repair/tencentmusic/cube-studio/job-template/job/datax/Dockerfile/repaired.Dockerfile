FROM ubuntu:18.04

# 安装运维工具
RUN apt update -y && apt install -y --no-install-recommends software-properties-common vim apt-transport-https gnupg2 ca-certificates-java rsync jq  wget git dnsutils iputils-ping net-tools curl mysql-client locales zip && rm -rf /var/lib/apt/lists/*;
# 安装python
RUN apt install --no-install-recommends -y python && rm -rf /var/lib/apt/lists/*;

# 安装datax
RUN wget https://datax-opensource.oss-cn-hangzhou.aliyuncs.com/datax.tar.gz && tar -zxvf datax.tar.gz -C /usr/local/ && rm -rf datax.tar.gz

# 安装中文
RUN apt install -y --force-yes --no-install-recommends locales ttf-wqy-microhei ttf-wqy-zenhei xfonts-wqy && locale-gen zh_CN && locale-gen zh_CN.utf8 && rm -rf /var/lib/apt/lists/*;
ENV LANG zh_CN.UTF-8
ENV LC_ALL zh_CN.UTF-8
ENV LANGUAGE zh_CN.UTF-8

### 安装java
RUN apt install --no-install-recommends -y openjdk-8-jdk && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/local/datax/bin

COPY start.sh /usr/local/datax/bin/start.sh

ENTRYPOINT ["bash","start.sh"]
