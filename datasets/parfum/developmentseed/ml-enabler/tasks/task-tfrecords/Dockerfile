FROM tensorflow/tensorflow:2.1.0-py3

ENV SHELL /bin/bash
ENV HOME=/home/task
WORKDIR $HOME

COPY ./ $HOME/retrain
WORKDIR $HOME/retrain

RUN mkdir /tmp/tfrecords

RUN apt-get update \
    && apt-get install -y git curl

RUN pip install -r requirements.txt

