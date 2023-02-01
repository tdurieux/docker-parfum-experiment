FROM python:3.6.8-jessie

ADD ./requirements.base.txt /code/
ADD ./requirements.no-gpu.txt /code/requirements.txt

WORKDIR /code

RUN apt-get update \
    && apt-get install --no-install-recommends -y build-essential mpich libpq-dev && rm -rf /var/lib/apt/lists/*;

# should merge to top RUN to avoid extra layers - for debug only :/
RUN pip install --no-cache-dir -r requirements.txt