# Take the base MXNet Container
ARG BASE_IMAGE=""

FROM $BASE_IMAGE

# Add Custom stack of code
RUN git clone -b v1.7.x https://github.com/apache/incubator-mxnet.git

# Repository to run EKS test case