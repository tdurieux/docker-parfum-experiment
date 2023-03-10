ARG region
FROM 763104351884.dkr.ecr.$region.amazonaws.com/mxnet-inference-eia:1.4.1-cpu-py3

COPY dist/sagemaker_mxnet_inference-*.tar.gz /sagemaker_mxnet_inference.tar.gz
RUN pip install --upgrade --no-cache-dir /sagemaker_mxnet_inference.tar.gz && \
    rm /sagemaker_mxnet_inference.tar.gz

# use sagemaker-inference version comaptible with MMS_VERSION=1.0.5
RUN pip install --upgrade --no-cache-dir sagemaker-inference==1.1.0