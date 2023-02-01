FROM shareai/tensorflow:x86_tf1.8

RUN mkdir -p /root/.ssh
COPY ./id_rsa /root/.ssh/id_rsa
RUN chmod 600 /root/.ssh/id_rsa
COPY ./sshconfig /root/.ssh/config

RUN cp /etc/apt/sources.list /etc/apt/sources.list.bk && \
    echo "deb http://ftp2.cn.debian.org/debian/ stretch main non-free contrib"           >  /etc/apt/sources.list && \
    echo "deb http://ftp2.cn.debian.org/debian/ stretch-updates main non-free contrib"   >> /etc/apt/sources.list && \
    echo "deb http://ftp2.cn.debian.org/debian/ stretch-backports main non-free contrib" >> /etc/apt/sources.list && \
    apt-get update && apt-get install --no-install-recommends -y libopenblas-base && apt-get clean && \
    mkdir -p /root/.local/lib/python2.7/site-packages/ && rm -rf /var/lib/apt/lists/*;
RUN cp /etc/apt/sources.list.bk /etc/apt/sources.list
COPY ./requirements.txt /root/requirements.txt
RUN pip install --no-cache-dir -r /root/requirements.txt
RUN pip install --no-cache-dir mxnet==1.2.0
