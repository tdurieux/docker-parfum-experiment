FROM python:3.6

ADD ./requirements.txt /tmp

RUN pip install --no-cache-dir -r /tmp/requirements.txt

RUN pip uninstall -y tensorflow && pip install --no-cache-dir tensorflow==1.5

RUN mkdir /2018.2-Lino

ADD . /2018.2-Lino

WORKDIR /2018.2-Lino/rasa

ENV TRAINING_EPOCHS=450

CMD python3 train-messenger.py all
