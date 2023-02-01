# A image for building paddle binaries
# Use cuda devel base image for both cpu and gpu environment
# When you modify it, please be aware of cudnn-runtime version
FROM paddlepaddle/paddle_manylinux_devel:cuda11.2-cudnn8.2.1-trt8.0.3.4-gcc82
MAINTAINER PaddlePaddle Authors <paddle-dev@baidu.com>


# Update golang version to 1.17.2