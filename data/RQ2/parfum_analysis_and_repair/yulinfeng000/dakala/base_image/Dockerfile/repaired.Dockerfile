FROM selenium/standalone-chrome:latest

USER root

COPY ./get-pip.py ./get-pip.py

RUN   sed -i "s/\/\/.*archive.ubuntu.com/\/\/mirrors.aliyun.com/g;s/\/\/.*security.ubuntu.com/\/\/mirrors.aliyun.com/g" /etc/apt/sources.list

RUN apt update -y && apt install --no-install-recommends python3-distutils -y && rm -rf /var/lib/apt/lists/*;

RUN python3 get-pip.py -i http://pypi.douban.com/simple/ --trusted-host pypi.douban.com
