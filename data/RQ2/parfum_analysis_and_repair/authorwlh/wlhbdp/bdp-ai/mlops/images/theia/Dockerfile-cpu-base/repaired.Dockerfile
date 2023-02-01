# docker build -t ccr.ccs.tencentyun.com/cube-studio/notebook:vscode-ubuntu-cpu-base -f Dockerfile-cpu-base .

FROM ccr.ccs.tencentyun.com/cube-studio/theia-python:latest

USER root
# 安装中文，和基础的apt工具包
RUN apt update && apt install -y --force-yes --no-install-recommends vim apt-transport-https gnupg2 ca-certificates-java rsync jq sysstat  wget git dnsutils iputils-ping net-tools curl mysql-client locales sysstat && apt clean && rm -rf /var/lib/apt/lists/*;

RUN echo "alias ll='ls -alF'" >> ~/.bashrc && \
    echo "alias la='ls -A'" >> ~/.bashrc && \
    echo "alias vi='vim'" >> ~/.bashrc && \
    /bin/bash -c "source ~/.bashrc"

RUN apt install --no-install-recommends -y libsasl2-dev libpq-dev && rm -f /usr/bin/python && rm -f /usr/local/bin/pip && rm -f /usr/bin/pip && ln -s /usr/local/bin/python3 /usr/bin/python && ln -s /usr/bin/pip3 /usr/bin/pip && rm -rf /var/lib/apt/lists/*;

# 安装python包
RUN pip3 install --no-cache-dir --upgrade pip && pip install --no-cache-dir gsutil pysnooper kubernetes simplejson sqlalchemy pandas numpy requests flask pymysql ray && \
    rm -rf /tmp/* /var/tmp/* ~/.cache


