# A image for building paddle binaries
# # Use cuda devel base image for both cpu and gpu environment
# # When you modify it, please be aware of cudnn-runtime version
FROM registry.baidubce.com/paddlepaddle/serving:0.8.0-cuda10.2-cudnn8-devel 
MAINTAINER PaddlePaddle Authors <paddle-dev@baidu.com>


# The docker has already installed maven.
RUN apt update && \
    apt install --no-install-recommends -y default-jre && \
    apt install --no-install-recommends -y default-jdk && \
    apt install --no-install-recommends -y maven && rm -rf /var/lib/apt/lists/*;

EXPOSE 22
