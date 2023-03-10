FROM ubuntu:bionic

ADD docker/docs/sources.list.ustc /etc/apt/sources.list
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && \
    apt install --no-install-recommends -y python3-pip python3-tk python-qt4 wget && \
    pip3 install --no-cache-dir -i https://pypi.tuna.tsinghua.edu.cn/simple tensorflow && rm -rf /var/lib/apt/lists/*;
ADD . /tensorlayer
WORKDIR /tensorlayer
RUN ln -s `which pip3` /usr/bin/pip && \
    ./scripts/install-horovod-for-doc-test.sh
RUN pip3 install --no-cache-dir -i https://pypi.tuna.tsinghua.edu.cn/simple .
RUN pip3 install --no-cache-dir -i https://pypi.tuna.tsinghua.edu.cn/simple -e .[all]
RUN make -C docs html
