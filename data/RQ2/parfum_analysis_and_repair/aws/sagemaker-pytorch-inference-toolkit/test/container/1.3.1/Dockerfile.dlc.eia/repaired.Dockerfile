ARG region
FROM 763104351884.dkr.ecr.$region.amazonaws.com/pytorch-inference-eia:1.3.1-cpu-py3

COPY dist/sagemaker_pytorch_inference-*.tar.gz /sagemaker_pytorch_inference.tar.gz
RUN pip install --upgrade --no-cache-dir /sagemaker_pytorch_inference.tar.gz && \
    rm /sagemaker_pytorch_inference.tar.gz