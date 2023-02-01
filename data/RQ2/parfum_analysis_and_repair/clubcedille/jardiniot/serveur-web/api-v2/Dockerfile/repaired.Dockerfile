FROM python:3.7


COPY . /app

RUN pip install --no-cache-dir pipenv

WORKDIR /app

RUN ./setup.sh

RUN pip install --no-cache-dir paho-mqtt

CMD pipenv run flask run & python3 /app/mqtt/mqttmain.py & python3 /app/mqtt/fakejardin.py
