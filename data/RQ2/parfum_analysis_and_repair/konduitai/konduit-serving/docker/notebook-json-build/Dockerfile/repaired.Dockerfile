FROM jupyter/base-notebook

RUN pip install --no-cache-dir jsonschema2popo
RUN pip install --no-cache-dir konduit
