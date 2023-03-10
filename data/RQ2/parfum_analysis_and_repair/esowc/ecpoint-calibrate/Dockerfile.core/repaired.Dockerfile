FROM continuumio/miniconda3 as build

RUN conda install -y -c conda-forge metview-batch python=3.8

ENV PYTHONPATH /app:$PYTHONPATH
ENV PIPENV_VENV_IN_PROJECT=1
ENV ECCODES_DEFINITION_PATH /opt/conda/share/eccodes/definitions
ENV PYTHONUNBUFFERED 1

RUN apt-get update && apt-get install -y  --no-install-recommends \
    build-essential \
    wait-for-it \
    fonts-arkpandora && rm -rf /var/lib/apt/lists/*;

RUN rm -rf /root/* /tmp/* /var/cache/apt/archives/*.deb /var/lib/apt/lists/*

RUN pip install --no-cache-dir -U pip wheel setuptools pipenv

WORKDIR /app

COPY Pipfile Pipfile.lock ./
RUN pipenv sync

COPY core core/

CMD [ "pipenv", "run", "server" ]
