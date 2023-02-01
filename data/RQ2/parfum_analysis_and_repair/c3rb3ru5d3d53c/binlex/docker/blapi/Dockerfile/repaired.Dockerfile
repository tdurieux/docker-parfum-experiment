FROM python:3.8

ENV LC_ALL=C
ENV DEBIAN_FRONTEND=noninteractive

COPY . /opt/binlex/

WORKDIR /opt/binlex/

RUN apt-get -qq -y update && \
    apt-get install --no-install-recommends -qq -y build-essential make cmake git wget nano curl nginx net-tools && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir gunicorn

WORKDIR /opt/binlex/lib/python/libblapi/

RUN ./setup.py install

WORKDIR /opt/binlex/docker/blapi/

RUN ./setup.py install

CMD ["sh", "start.sh"]
