ARG version=3.8
FROM python:${version}

WORKDIR /workspace
RUN pip install --no-cache-dir --upgrade pip \
    && apt-get update \
    && apt-get install --no-install-recommends -y \
        freetds-dev \
    && rm -rf /var/lib/apt/lists/*
ARG version=3.8
COPY requirements/${version}.txt requirements.txt
COPY setup.py README.rst ./
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
