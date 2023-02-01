FROM postgres:9.4

RUN apt-get update && apt-get install --no-install-recommends --yes \
    postgresql-9.4-python-multicorn \
    python \
    python-pip && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir elasticsearch

COPY . /pg-es-fdw
WORKDIR /pg-es-fdw
RUN python setup.py install
