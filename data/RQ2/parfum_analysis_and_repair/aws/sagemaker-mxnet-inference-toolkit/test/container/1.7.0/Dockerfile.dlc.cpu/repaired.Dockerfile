ARG region
FROM 763104351884.dkr.ecr.$region.amazonaws.com/mxnet-inference:1.6.0-cpu-py2

COPY dist/sagemaker_mxnet_inference-*.tar.gz /sagemaker_mxnet_inference.tar.gz
RUN pip install --upgrade --no-cache-dir /sagemaker_mxnet_inference.tar.gz && \
    rm /sagemaker_mxnet_inference.tar.gz