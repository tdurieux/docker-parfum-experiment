FROM hub.baidubce.com/paddlepaddle/paddle:<baseimg>

# gcc 5
RUN ln -sf /usr/bin/gcc-5 /usr/bin/gcc
# python3 default use python3.6
RUN ln -sf /usr/local/bin/python3.6 /usr/local/bin/python3

# Install Go
RUN rm -rf /usr/local/go && wget -qO- https://dl.google.com/go/go1.13.10.linux-amd64.tar.gz | \
    tar -xz -C /usr/local && \
    mkdir -p /root/gopath && \
    mkdir -p /root/gopath/bin && \
    mkdir -p /root/gopath/src
ENV GOROOT=/usr/local/go GOPATH=/root/gopath
# should not be in the same line with GOROOT definition, otherwise docker build could not find GOROOT.
ENV PATH=$PATH:{GOROOT}/bin:${GOPATH}/bin

ADD ./docker/requirements.txt /root/paddle_edl/requirements.txt
RUN python -m pip install pip==20.1.1
RUN python3.6 -m pip install pip==20.1.1
RUN python3.6 -m pip install --upgrade setuptools
RUN python -m pip install -r /root/paddle_edl/requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple
RUN python3.6 -m pip install -r /root/paddle_edl/requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple

# etcd
ENV HOME /root
WORKDIR /root/paddle_edl
ADD ./scripts/download_etcd.sh /root/paddle_edl/download_etcd.sh
RUN bash /root/paddle_edl/download_etcd.sh

# Install redis
RUN cd /tmp/ && wget -q https://paddle-edl.bj.bcebos.com/redis-6.0.1.tar.gz &&  \
    tar xzf redis-6.0.1.tar.gz && \
    cd redis-6.0.1 && make -j && \
    mv src/redis-server /usr/local/bin && \
    mv src/redis-cli /usr/local/bin && \
    cd .. && rm -rf redis-6.0.1.tar.gz redis-6.0.1

RUN echo "export PATH=$PATH:${GOROOT}/bin:${GOPATH}/bin" >> /root/.bashrc
RUN echo "go env -w GO111MODULE=on && go env -w GOPROXY=https://goproxy.io,direct" >> /root/.bashrc
ENV GO111MODULE=on
ENV GOPROXY=https://goproxy.io,direct

# install edl
ADD ./build/python/dist/paddle_edl-0.0.0-py2.py3-none-any.whl /tmp/paddle_edl-0.0.0-py2.py3-none-any.whl
RUN python -m pip install /tmp/paddle_edl-0.0.0-py2.py3-none-any.whl
RUN python3.6 -m pip install /tmp/paddle_edl-0.0.0-py2.py3-none-any.whl
RUN rm -f /tmp/paddle_edl-0.0.0-py2.py3-none-any.whl

# add example
ADD ./example /root/paddle_edl/example
ADD  ./k8s/k8s_tools.py ./example/distill/k8s/edl_k8s /root/paddle_edl/

# add mnist distill teacher model
RUN cd /root/paddle_edl/example/distill/mnist_distill && \
    wget -q https://paddle-edl.bj.bcebos.com/distill_teacher_model/mnist_cnn_model.tar.gz && \
    tar xzf mnist_cnn_model.tar.gz && rm mnist_cnn_model.tar.gz
