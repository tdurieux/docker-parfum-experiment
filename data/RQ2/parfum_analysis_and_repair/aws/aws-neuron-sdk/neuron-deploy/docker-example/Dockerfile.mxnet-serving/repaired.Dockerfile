# To build:
#    docker build . -f Dockerfile.mxnet-serving -t mxnet-model-server-neuron

FROM amazonlinux:2

ENV PYTHONUNBUFFERED TRUE

RUN yum install -y gcc-c++ && rm -rf /var/cache/yum
RUN yum install -y python3-devel && rm -rf /var/cache/yum
RUN yum install -y java-1.8.0-openjdk && rm -rf /var/cache/yum
RUN yum install -y curl && rm -rf /var/cache/yum
RUN cd /tmp \
    && curl -f -O https://bootstrap.pypa.io/get-pip.py \
    && python3 get-pip.py

RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1
RUN update-alternatives --install /usr/local/bin/pip pip /usr/local/bin/pip3 1
RUN pip install --no-cache-dir mxnet-neuron --extra-index-url=https://pip.repos.neuron.amazonaws.com
RUN pip install --no-cache-dir multi-model-server


RUN useradd -m model-server \
    && mkdir -p /home/model-server/tmp

COPY dockerd-entrypoint.sh /usr/local/bin/dockerd-entrypoint.sh

RUN mkdir -p /home/model-server/tmp/models/
#copy your model
COPY mxnet_model/resnet-50_compiled.mar  /home/model-server/tmp/models/

RUN chmod +x /usr/local/bin/dockerd-entrypoint.sh \
    && chown -R model-server /home/model-server

EXPOSE 8080 8081

USER model-server
WORKDIR /home/model-server
ENV TEMP=/home/model-server/tmp
ENTRYPOINT ["/usr/local/bin/dockerd-entrypoint.sh"]
CMD ["serve"]
