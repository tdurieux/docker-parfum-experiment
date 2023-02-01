FROM tensorflow/tensorflow

MAINTAINER Ben Carson "ben.carson@bigpond.com"

# Version of Pillow in the container is O.L.D.
RUN pip install --no-cache-dir --upgrade pillow blinker requests

ADD . /opt/oversight/

RUN chmod +x /opt/oversight/bin/*

CMD cd /opt/oversight && python oversight_runner.py
