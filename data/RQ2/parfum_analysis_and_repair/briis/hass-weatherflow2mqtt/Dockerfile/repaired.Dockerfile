FROM python:3.10-slim-buster
LABEL org.opencontainers.image.source="https://github.com/briis/hass-weatherflow2mqtt"

RUN mkdir -p /data
RUN mkdir -p /src/weatherflow2mqtt
WORKDIR /src/weatherflow2mqtt
ADD requirements.txt test_requirements.txt /src/weatherflow2mqtt/
RUN apt-get clean
RUN apt-get update && \
    apt-get -y --no-install-recommends install build-essential && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

ADD setup.py /src/weatherflow2mqtt/
ADD translations /src/weatherflow2mqtt/translations/

ADD weatherflow2mqtt /src/weatherflow2mqtt/weatherflow2mqtt/
RUN python setup.py install


ENV TZ=Europe/Copenhagen

EXPOSE 50222/udp
EXPOSE 1883

CMD [ "weatherflow2mqtt" ]
