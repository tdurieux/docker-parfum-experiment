FROM ubuntu:18.04

# 安装运维工具
RUN apt-get update && apt install -y --force-yes --no-install-recommends vim apt-transport-https gnupg2 ca-certificates-java rsync jq  wget git dnsutils iputils-ping net-tools curl locales zip
# 安装python
RUN apt install -y python3.6-dev python3-pip libsasl2-dev libpq-dev \
    && ln -s /usr/bin/python3 /usr/bin/python \
    && ln -s /usr/bin/pip3 /usr/bin/pip

# 安装中文
RUN apt install -y --force-yes --no-install-recommends locales ttf-wqy-microhei ttf-wqy-zenhei xfonts-wqy && locale-gen zh_CN && locale-gen zh_CN.utf8
ENV LANG zh_CN.UTF-8
ENV LC_ALL zh_CN.UTF-8
ENV LANGUAGE zh_CN.UTF-8

# 便捷操作
RUN echo "alias ll='ls -alF'" >> /root/.bashrc && \
    echo "alias la='ls -A'" >> /root/.bashrc && \
    echo "alias vi='vim'" >> /root/.bashrc && \
    /bin/bash -c "source /root/.bashrc"


RUN pip install kubernetes==12.0.1 pysnooper psutil
COPY job/deploy-service/* /app/

WORKDIR /app
ENV PYTHONPATH=/app:$PYTHONPATH

ENTRYPOINT ["python3", "launcher.py"]


