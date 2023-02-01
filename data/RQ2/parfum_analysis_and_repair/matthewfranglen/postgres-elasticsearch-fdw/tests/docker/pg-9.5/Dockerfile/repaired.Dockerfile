FROM postgres:9.5

ARG ES_PIP_VERSION

RUN apt-get update && apt-get install --no-install-recommends --yes --force-yes \
    build-essential \
    libffi-dev \
    libssl-dev \
    postgresql-9.5-python-multicorn \
    python \
    python-dev \
    python-pip && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir $ES_PIP_VERSION

COPY . /pg-es-fdw
WORKDIR /pg-es-fdw
RUN python setup.py install
