FROM balenalib/%%BALENA_MACHINE_NAME%%-python:3.7-buster-build

RUN install_packages python3-smbus wget unzip

RUN pip3 install --no-cache-dir --upgrade \
  pip \
  setuptools \
  wheel \
  smbus2 \
  RPi.GPIO \
  balena-sdk \
  automationhat \
  paho-mqtt

RUN python3 -m pip install --no-cache-dir --trusted-host pypi.python.org Adafruit_DHT==1.4.0 --install-option="--force-pi2"

COPY . /usr/src

CMD python /usr/src/start.py