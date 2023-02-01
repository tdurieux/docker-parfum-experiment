FROM python:3.6.8-jessie

ADD ./requirements.base.txt /code/
ADD ./requirements.txt /code/

WORKDIR /code

RUN apt-get update \
    && apt-get install --no-install-recommends -y build-essential mpich libpq-dev \
    && pip install --no-cache-dir -r requirements.txt && rm -rf /var/lib/apt/lists/*;