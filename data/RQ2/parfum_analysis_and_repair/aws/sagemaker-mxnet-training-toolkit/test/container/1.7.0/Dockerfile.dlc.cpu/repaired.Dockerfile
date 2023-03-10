ARG region
FROM 763104351884.dkr.ecr.$region.amazonaws.com/mxnet-training:1.6.0-cpu-py2

COPY dist/sagemaker_mxnet_training-*.tar.gz /sagemaker_mxnet_training.tar.gz
RUN pip install --upgrade --no-cache-dir /sagemaker_mxnet_training.tar.gz && \
    rm /sagemaker_mxnet_training.tar.gz