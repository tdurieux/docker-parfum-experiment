FROM nvidia/cuda:7.5-cudnn5-devel
# the reason we used a gpu base container because we are going to test MKLDNN
# operator implementation against GPU implementation

COPY install/ubuntu_*.sh /install/

RUN /install/ubuntu_install_core.sh
RUN /install/ubuntu_install_python.sh
RUN /install/ubuntu_install_scala.sh

RUN wget --no-check-certificate -O /tmp/mklml.tgz https://github.com/dmlc/web-data/raw/master/mxnet/mklml-release/mklml_lnx_2017.0.2.20170209.tgz
RUN tar -zxvf /tmp/mklml.tgz && cp -rf mklml_*/* /usr/local/ && rm -rf mklml_*

ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/lib
