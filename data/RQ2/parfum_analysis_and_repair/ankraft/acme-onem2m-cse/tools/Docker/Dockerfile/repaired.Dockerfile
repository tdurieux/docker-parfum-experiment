FROM python:3.8

RUN apt-get update && apt-get -y update

RUN pip3 install --no-cache-dir cbor2
RUN pip3 install --no-cache-dir flask
RUN pip3 install --no-cache-dir isodate
RUN pip3 install --no-cache-dir paho-mqtt
RUN pip3 install --no-cache-dir requests
RUN pip3 install --no-cache-dir rich
RUN pip3 install --no-cache-dir tinydb

RUN mkdir acme-cse
COPY tools/Docker/acme.docker acme-cse/acme.ini
COPY acme/ acme-cse/acme/
COPY apps/ acme-cse/apps/
COPY init/ acme-cse/init/
WORKDIR acme-cse/

CMD ["python3", "acme"]
