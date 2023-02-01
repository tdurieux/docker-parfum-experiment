FROM bentoml/model-server:0.11.0-slim-py37

RUN pip install --no-cache-dir pysmiles

WORKDIR /repo
COPY . /repo
