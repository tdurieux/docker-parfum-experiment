ARG region
FROM 763104351884.dkr.ecr.$region.amazonaws.com/tensorflow-training:1.15.2-cpu-py2

COPY dist/sagemaker_tensorflow_training-*.tar.gz /sagemaker_tensorflow_training.tar.gz
RUN pip install --upgrade --no-cache-dir /sagemaker_tensorflow_training.tar.gz && \
    rm /sagemaker_tensorflow_training.tar.gz