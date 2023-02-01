FROM python:3.6.8-jessie

ADD ./requirements.base.txt /code/
ADD ./requirements.no-gpu.txt /code/
ADD ./requirements.tests.txt /code/requirements.txt

WORKDIR /code

RUN apt-get update \
    && apt-get install --no-install-recommends -y build-essential mpich libpq-dev \
    && pip install --no-cache-dir --progress-bar off --requirement requirements.txt && rm -rf /var/lib/apt/lists/*;