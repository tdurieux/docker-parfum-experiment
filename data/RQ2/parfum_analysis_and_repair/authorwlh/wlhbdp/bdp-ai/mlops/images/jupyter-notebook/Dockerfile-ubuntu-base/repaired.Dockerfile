# docker build -t ccr.ccs.tencentyun.com/cube-studio/notebook:jupyter-ubuntu-cpu-base -f Dockerfile-ubuntu-cpu-base .
ARG FROM_IMAGES
FROM $FROM_IMAGES
# FROM ubuntu:18.04

USER root
# 安装中文，和基础的apt工具包
RUN apt update && apt install -y --force-yes --no-install-recommends software-properties-common vim apt-transport-https gnupg2 ca-certificates-java rsync jq  wget git dnsutils iputils-ping net-tools curl mysql-client locales ttf-wqy-microhei ttf-wqy-zenhei xfonts-wqy && \
    locale-gen zh_CN && locale-gen zh_CN.utf8 && rm -rf /var/lib/apt/lists/*;

ENV LANG zh_CN.UTF-8
ENV LC_ALL zh_CN.UTF-8
ENV LANGUAGE zh_CN.UTF-8

RUN echo "alias ll='ls -alF'" >> /root/.bashrc && \
    echo "alias la='ls -A'" >> /root/.bashrc && \
    echo "alias vi='vim'" >> /root/.bashrc && \
    /bin/bash -c "source /root/.bashrc"

# 安装python
RUN add-apt-repository -y ppa:deadsnakes/ppa && apt update && apt install --no-install-recommends -y libsasl2-dev libpq-dev python3-pip && rm -rf /var/lib/apt/lists/*;

RUN apt install --no-install-recommends -y python3.8 && rm -rf /usr/bin/python && ln -s /usr/bin/python3.8 /usr/bin/python && rm -rf /var/lib/apt/lists/*;

RUN bash -c "wget https://bootstrap.pypa.io/get-pip.py && python get-pip.py --ignore-installed --force-reinstall" \
    && rm -rf /usr/bin/pip && ln -s /usr/bin/pip3 /usr/bin/pip

RUN pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir gsutil pysnooper psycopg2-binary jupyter-tensorboard kubernetes simplejson sqlalchemy redis pandas joblib numpy xgboost scikit-learn seldon-core tornado sklearn kazoo jinja2 requests numpy pandas flask pymysql Flask-APScheduler pysnooper pyyaml kubernetes jupyterlab voila notebook && \
    rm -rf /tmp/* /var/tmp/* /root/.cache


# 安装最新版的nodejs
RUN curl -f -sL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && npm config set unicode false && rm -rf /var/lib/apt/lists/*;

# 环境变量
ENV NODE_HOME /usr/local
ENV PATH $NODE_HOME/bin:$PATH
ENV NODE_PATH $NODE_HOME/lib/node_modules:$PATH
ENV SHELL /bin/bash


# jupyter lab --notebook-dir=/home --ip=0.0.0.0 --no-browser --allow-root --port=8888 --NotebookApp.token='' --NotebookApp.password='' --NotebookApp.allow_origin='*'



