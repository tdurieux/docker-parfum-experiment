FROM pai.build.base:hadoop2.7.2-cuda8.0-cudnn6-devel-ubuntu16.04

# install git
RUN apt-get -y update && apt-get -y install git

# install MXNet dependeces using pip
RUN pip install mxnet-cu80

# clone MXNet examples
RUN git clone -b v1.2.0 https://github.com/apache/incubator-mxnet.git

#if you want to build the docker image with data, please prepare the data first and remove the '#' in next line
#ADD ./mnist-original.mat /root/incubator-mxnet/data/mldata/
