ARG py_version
FROM pytorch-base:1.1.0-cpu-py$py_version

LABEL com.amazonaws.sagemaker.capabilities.accept-bind-to-port=true

# Copy workaround script for incorrect hostname
COPY lib/changehostname.c /
COPY lib/start_with_right_hostname.sh /usr/local/bin/start_with_right_hostname.sh
RUN chmod +x /usr/local/bin/start_with_right_hostname.sh

COPY dist/sagemaker_pytorch_container-1.1-py2.py3-none-any.whl /sagemaker_pytorch_container-1.1-py2.py3-none-any.whl
RUN pip install --no-cache-dir /sagemaker_pytorch_container-1.1-py2.py3-none-any.whl && \
    rm /sagemaker_pytorch_container-1.1-py2.py3-none-any.whl

ENV SAGEMAKER_TRAINING_MODULE sagemaker_pytorch_container.training:main
ENV SAGEMAKER_SERVING_MODULE sagemaker_pytorch_container.serving:main

# Starts framework
ENTRYPOINT ["bash", "-m", "start_with_right_hostname.sh"]