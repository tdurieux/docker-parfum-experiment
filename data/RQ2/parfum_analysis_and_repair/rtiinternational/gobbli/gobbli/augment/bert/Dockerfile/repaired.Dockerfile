FROM pytorch/pytorch:1.3-cuda10.1-cudnn7-runtime

RUN pip install --no-cache-dir transformers==2.3.0 sentencepiece==0.1.86

COPY ./src /code/bert
WORKDIR /code/bert
