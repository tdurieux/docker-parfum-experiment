FROM pytorch/pytorch:1.3-cuda10.1-cudnn7-runtime

COPY ./src/requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt

COPY ./src /code/transformer
WORKDIR /code/transformer
