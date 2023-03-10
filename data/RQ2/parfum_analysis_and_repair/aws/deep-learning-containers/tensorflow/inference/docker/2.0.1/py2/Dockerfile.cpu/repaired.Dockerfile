FROM ubuntu:18.04

LABEL maintainer="Amazon AI"
LABEL dlc_major_version="5"

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    emacs \
    git \
    wget \
    vim \
 && rm -rf /var/lib/apt/lists/*

# See http://bugs.python.org/issue19846
ENV LANG C.UTF-8

# Add arguments to achieve the version, python and url
#  PYTHON=python for 2.7
#  PYTHON=python3 for 3.5, 3.6 is not available directly on 16.04
ARG PYTHON=python

# user python-pip or python3-pip
ARG PYTHON_PIP=python-pip

#  PIP=pip for 2.7
#  PIP=pip3 for 3.5, 3.6 is not available directly on 16.04
ARG PIP=pip

# Python won’t try to write .pyc or .pyo files on the import of source modules
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y --no-install-recommends \
    ${PYTHON} \
    ${PYTHON_PIP} && rm -rf /var/lib/apt/lists/*;

RUN ${PIP} --no-cache-dir install --upgrade \
    pip \
    setuptools

# Some TF tools expect a "python" binary
RUN ln -s $(which ${PYTHON}) /usr/local/bin/python

RUN curl -f https://tensorflow-aws.s3-us-west-2.amazonaws.com/MKL-Libraries/libiomp5.so -o /usr/local/lib/libiomp5.so
RUN curl -f https://tensorflow-aws.s3-us-west-2.amazonaws.com/MKL-Libraries/libmklml_intel.so -o /usr/local/lib/libmklml_intel.so

ENV LD_LIBRARY_PATH '/usr/local/lib:$LD_LIBRARY_PATH'

RUN curl -f https://tensorflow-aws.s3-us-west-2.amazonaws.com/2.0.1/Serving/CPU-WITH-MKL/tensorflow_model_server -o /usr/bin/tensorflow_model_server \
 && chmod 555 /usr/bin/tensorflow_model_server

RUN ${PIP} install -U --no-cache-dir \
    docutils==0.15.2 \
    "awscli<2" \
    requests==2.22.0

# Expose ports
# gRPC
EXPOSE 8500

# REST
EXPOSE 8501

# Set where models should be stored in the container
ENV MODEL_BASE_PATH=/models
RUN mkdir -p ${MODEL_BASE_PATH}

# The only required piece is the model name in order to differentiate endpoints
ENV MODEL_NAME=model

# Create a script that runs the model server so we can use environment variables
# while also passing in arguments from the docker command line
RUN echo '#!/bin/bash \n\n\
tensorflow_model_server --port=8500 --rest_api_port=8501 \
--model_name=${MODEL_NAME} --model_base_path=${MODEL_BASE_PATH}/${MODEL_NAME} \
"$@"' > /usr/bin/tf_serving_entrypoint.sh \
&& chmod +x /usr/bin/tf_serving_entrypoint.sh

RUN curl -f https://aws-dlc-licenses.s3.amazonaws.com/tensorflow-2.0/license.txt -o /license.txt

CMD ["/usr/bin/tf_serving_entrypoint.sh"]
