FROM centos:7

RUN yum update -y
RUN yum install --assumeyes gcc-c++ python3 python3-devel python3-pip java-1.8.0-openjdk-devel make diffutils && rm -rf /var/cache/yum
RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install konlpy

RUN yum install --assumeyes curl git && rm -rf /var/cache/yum
RUN curl -f -s https://raw.githubusercontent.com/konlpy/konlpy/master/scripts/mecab.sh | bash

RUN yum install --assumeyes git && rm -rf /var/cache/yum
RUN git clone https://github.com/konlpy/konlpy konlpy.git
WORKDIR konlpy.git
RUN git checkout master
RUN python3 -m pip install -r requirements-dev.txt
CMD python3 -m pytest -v .
