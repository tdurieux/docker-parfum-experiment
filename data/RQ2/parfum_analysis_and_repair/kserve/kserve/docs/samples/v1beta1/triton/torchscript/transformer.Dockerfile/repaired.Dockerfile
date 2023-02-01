FROM python:3.7-slim
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir git+https://github.com/kubeflow/kfserving@torchscript#subdirectory=python/kfserving
COPY . .
RUN pip install --no-cache-dir -e .
ENTRYPOINT ["python", "-m", "image_transformer_v2"]
