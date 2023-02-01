FROM tensorflow/tensorflow:2.1.0-py3

ENV SHELL /bin/bash
ENV HOME=/home/task
WORKDIR $HOME

COPY ./ $HOME/retrain
WORKDIR $HOME/retrain

RUN mkdir /tmp/tfrecords

RUN apt-get update \
    && apt-get install --no-install-recommends -y git curl && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir -r requirements.txt

