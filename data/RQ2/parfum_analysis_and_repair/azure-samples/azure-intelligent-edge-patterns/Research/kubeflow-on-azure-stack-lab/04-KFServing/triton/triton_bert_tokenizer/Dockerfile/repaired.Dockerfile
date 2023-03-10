#
# See the original for the latest version: https://github.com/kubeflow/kfserving/tree/master/docs/samples
#
FROM python:3.7-slim
RUN apt-get update \
  && apt-get install --no-install-recommends -y wget \
  && rm -rf /var/lib/apt/lists/*
COPY bert_transformer bert_transformer/bert_transformer
COPY setup.py bert_transformer/setup.py
RUN pip install --no-cache-dir kfserving
RUN wget https://github.com/triton-inference-server/server/releases/download/v1.11.0/v1.11.0_ubuntu1604.clients.tar.gz && tar -xvzf v1.11.0_ubuntu1604.clients.tar.gz && rm v1.11.0_ubuntu1604.clients.tar.gz
RUN pip install --no-cache-dir python/tensorrtserver-1.11.0-py3-none-linux_x86_64.whl
WORKDIR bert_transformer
RUN pip install --no-cache-dir -e .
ENTRYPOINT ["python", "-m", "bert_transformer"]
