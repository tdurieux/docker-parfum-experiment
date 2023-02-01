FROM python:3.8-buster

RUN apt-get update && apt install --no-install-recommends git -y && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/local/bin/

RUN git clone https://github.com/danionescu0/home-automation.git home-automation

WORKDIR /usr/local/bin/home-automation/hass-sensors

RUN pip install --no-cache-dir -qr requirements.txt

ENV MQTT_SERVER=localhost

ENV SERIAL_PORT=/dev/ttyUSB0

CMD python ./server.py ${SERIAL_PORT} ${MQTT_SERVER}