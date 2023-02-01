FROM postgres:12

ARG ES_PIP_VERSION

RUN apt-get update && apt-get install --no-install-recommends --yes \
    postgresql-12-python3-multicorn \
    python3 \
    python3-setuptools \
    python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir $ES_PIP_VERSION

COPY . /pg-es-fdw
WORKDIR /pg-es-fdw
RUN python3 setup.py install
