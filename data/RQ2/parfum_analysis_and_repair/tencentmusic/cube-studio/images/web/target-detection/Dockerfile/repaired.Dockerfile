# docker build -t ccr.ccs.tencentyun.com/cube-studio/target-detection  .

FROM ubuntu:18.04

RUN apt update

# 安装运维工具
RUN apt install -y --force-yes --no-install-recommends vim apt-transport-https gnupg2 ca-certificates-java rsync jq wget git dnsutils iputils-ping net-tools curl mysql-client locales zip && rm -rf /var/lib/apt/lists/*;

# 安装python
RUN apt install --no-install-recommends -y python3.6-dev python3-pip libsasl2-dev libpq-dev \
	&& ln -s /usr/bin/python3 /usr/bin/python \
	&& ln -s /usr/bin/pip3 /usr/bin/pip \
	&& pip install --no-cache-dir --upgrade pip && rm -rf /var/lib/apt/lists/*;


# 安装中文
RUN apt install -y --force-yes --no-install-recommends locales ttf-wqy-microhei ttf-wqy-zenhei xfonts-wqy && locale-gen zh_CN && locale-gen zh_CN.utf8 && rm -rf /var/lib/apt/lists/*;
ENV LANG zh_CN.UTF-8
ENV LC_ALL zh_CN.UTF-8
ENV LANGUAGE zh_CN.UTF-8

# 便捷操作
RUN echo "alias ll='ls -alF'" >> /root/.bashrc && \
	echo "alias la='ls -A'" >> /root/.bashrc && \
	echo "alias vi='vim'" >> /root/.bashrc && \
	/bin/bash -c "source /root/.bashrc"

RUN apt install --no-install-recommends -y libgl1-mesa-glx && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir flask werkzeug requests tornado
RUN pip install --no-cache-dir Pillow pysnooper opencv-python

RUN pip3 install --no-cache-dir https://github.com/danielgatis/darknetpy/raw/master/dist/darknetpy-4.1-cp36-cp36m-linux_x86_64.whl
WORKDIR /app
#RUN wget https://pengluan-76009.sz.gfp.tencent-cloud.com/github/yolov3.zip && apt install unzip && unzip yolov3.zip && rm yolov3.zip
COPY . /app/
ENTRYPOINT ["python", "server-web.py"]
# docker run --name darknet --privileged -it --rm -v $PWD:/app -p 8080:8080 --entrypoint='' ccr.ccs.tencentyun.com/cube-studio/target-detection  bash

