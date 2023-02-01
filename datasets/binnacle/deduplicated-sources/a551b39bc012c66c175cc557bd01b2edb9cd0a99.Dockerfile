ARG CUDA_VERSION
ARG TF_VERSION
ARG BAZEL_VERSION
ARG CUB_VERSION
ARG OPENCV_VERSION
ARG GO_VERSION
FROM tensorflow:ubuntu16.04-cuda${CUDA_VERSION}-bazel${BAZEL_VERSION}-tensorflow${TF_VERSION}
LABEL maintainer="Patrick Wieschollek <mail@patwie.com>"

ARG TF_VERSION
ARG BAZEL_VERSION
ARG CUB_VERSION
ARG OPENCV_VERSION
ARG GO_VERSION


#RUN apt-get install golang-go -yy
WORKDIR /tmp
RUN wget https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz
RUN tar -xvf go${GO_VERSION}.linux-amd64.tar.gz
RUN mv go /usr/local
ENV GOROOT=/usr/local/go

WORKDIR /root


ENV GOPATH=/gocode
ENV PATH=$GOROOT/bin:$PATH

