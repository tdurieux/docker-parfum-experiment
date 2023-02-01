FROM python:3.7-slim

WORKDIR /

RUN apt update && apt install --no-install-recommends -y gcc libffi-dev git && rm -rf /var/lib/apt/lists/*;
RUN git clone -b 0.2.2 https://github.com/kubeflow/kfserving.git

RUN pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir /kfserving/python/kfserving

RUN chmod +x /kfserving/python/storage-initializer/scripts/initializer-entrypoint
ENTRYPOINT ["/kfserving/python/storage-initializer/scripts/initializer-entrypoint"]