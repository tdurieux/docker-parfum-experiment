FROM jinaai/jina:1.2.1 as base

RUN apt-get update && apt-get install -y --no-install-recommends libgomp1 && rm -rf /var/lib/apt/lists/*;

# setup the workspace
COPY . /workspace
WORKDIR /workspace

# install the third-party requirements
RUN pip install --no-cache-dir -r requirements.txt

# for testing the image
FROM base
RUN pip install --no-cache-dir pytest sklearn && pytest -v -s

FROM base
RUN pip install --no-cache-dir pytest sklearn && \
    python -c 'from tests.test_lightgbmranker import _pretrained_model; import os; os.mkdir("tmp"); model_path = os.path.join("tmp", "model.txt"); _pretrained_model(model_path)' && \
    pip uninstall -y sklearn pytest
ENTRYPOINT ["jina", "pod", "--uses", "config.yml"]
