ARG region
FROM 763104351884.dkr.ecr.$region.amazonaws.com/pytorch-inference:1.5.0-cpu-py3

ARG TS_VERSION=0.1.1
RUN apt-get update \
    && apt-get install -y --no-install-recommends software-properties-common \
    && add-apt-repository ppa:openjdk-r/ppa \
    && apt-get update \
    && apt-get install -y --no-install-recommends openjdk-11-jdk && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir torchserve==$TS_VERSION \
    && pip install --no-cache-dir torch-model-archiver==$TS_VERSION

COPY dist/sagemaker_pytorch_inference-*.tar.gz /sagemaker_pytorch_inference.tar.gz
RUN pip install --upgrade --no-cache-dir /sagemaker_pytorch_inference.tar.gz && \
    rm /sagemaker_pytorch_inference.tar.gz

CMD ["torchserve", "--start", "--ts-config", "/home/model-server/config.properties", "--model-store", "/home/model-server/"]
