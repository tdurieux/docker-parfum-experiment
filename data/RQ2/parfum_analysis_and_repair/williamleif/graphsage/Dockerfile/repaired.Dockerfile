FROM tensorflow/tensorflow:1.3.0

RUN pip install --no-cache-dir networkx==1.11
RUN rm /notebooks/*

COPY . /notebooks
