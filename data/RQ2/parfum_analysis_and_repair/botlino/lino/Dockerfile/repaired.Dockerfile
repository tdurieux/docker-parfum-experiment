FROM python:3.6

RUN pip install --no-cache-dir rasa_core==0.13.1

RUN pip install --no-cache-dir rasa_nlu==0.14.0

RUN pip install --no-cache-dir rasa_nlu[tensorflow]

RUN pip install --no-cache-dir pymongo
RUN pip install --no-cache-dir requests

RUN mkdir /2018.2-Lino

ADD . /2018.2-Lino

WORKDIR /2018.2-Lino/rasa

ENV TRAINING_EPOCHS=300 \
    CREDENTIALS="./rasa/credentials.yml"

CMD python train.py all
