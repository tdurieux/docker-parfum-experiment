ARG region
from 763104351884.dkr.ecr.$region.amazonaws.com/pytorch-training:1.6.0-cpu-py36-ubuntu16.04

COPY lib/changehostname.c /
COPY lib/start_with_right_hostname.sh /usr/local/bin/start_with_right_hostname.sh
RUN chmod +x /usr/local/bin/start_with_right_hostname.sh

COPY dist/sagemaker_pytorch_training-*.tar.gz /sagemaker_pytorch_training.tar.gz
RUN pip install --upgrade --no-cache-dir /sagemaker_pytorch_training.tar.gz && \
    rm /sagemaker_pytorch_training.tar.gz