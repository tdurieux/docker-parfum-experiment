# syntax = docker/dockerfile:experimental
FROM quay.io/pypa/manylinux2014_x86_64

ENV PATH=/opt/python/cp37-cp37m/bin:${PATH}

RUN --mount=type=cache,target=/root/.cache \
    pip install \
        pyinstaller==3.6.*

WORKDIR /src
ENV VIRTUAL_ENV=/venv

RUN python3 -m venv /venv \
    && /venv/bin/python -m pip install --upgrade pip wheel
ENV PATH=/venv/bin:$PATH

COPY vendor/env/share/gdal/ /venv/share/gdal/
COPY vendor/env/share/proj/ /venv/share/proj/
COPY vendor/env/lib/ /venv/lib/
COPY vendor/env/bin/git /venv/bin/

COPY requirements.txt /src/
RUN --mount=type=cache,target=/root/.cache \
    pip install --no-deps -r requirements.txt

COPY vendor/wheelhouse/*-linux_x86_64.whl /src
RUN pip install --no-deps /src/*.whl

COPY setup.py /src/
COPY kart/ /src/kart/
RUN --mount=type=cache,target=/root/.cache \
    pip install --no-deps . \
    && kart --version
