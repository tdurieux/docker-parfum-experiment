FROM centos:7
MAINTAINER XuMing "xuming624@qq.com"

RUN  yum -y install python36
RUN  yum -y install git boost-devel boost-test boost zlib bzip2 xz cmake make
RUN  yum -y install gcc-c++
RUN  yum -y install python36-devel
# install kenlm
RUN pip3 install https://github.com/kpu/kenlm/archive/master.zip
# clone repo
#RUN git clone --depth=1 https://github.com/shibing624/pycorrector.git
#WORKDIR /home/work/pycorrector
# install requirements.txt
RUN pip3 install jieba pypinyin numpy six -i https://pypi.tuna.tsinghua.edu.cn/simple
# install pycorrector by pip3
RUN pip3 install pycorrector -i https://pypi.tuna.tsinghua.edu.cn/simple
# support chinese with utf-8
RUN localedef -c -f UTF-8 -i zh_CN zh_CN.utf8
ENV LC_ALL zh_CN.UTF-8

CMD /bin/bash