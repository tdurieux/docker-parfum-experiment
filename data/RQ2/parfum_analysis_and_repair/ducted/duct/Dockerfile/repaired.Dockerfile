FROM python:2.7.15-slim-stretch

WORKDIR /duct

RUN apt-get update && apt-get -y --no-install-recommends install build-essential python-cryptography python-twisted python-protobuf python-yaml python-openssl && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y upgrade


RUN mkdir -p /duct/conf.d

ADD duct duct
ADD twisted twisted
ADD requirements.txt .
ADD setup.py .
ADD docker/duct.yml .

RUN pip install --no-cache-dir -e .

RUN apt-get -y purge build-essential
RUN apt-get -y autoremove
RUN apt-get clean

USER 65534

CMD twistd --pidfile=/tmp/duct.pid -n duct -c /duct/duct.yml
