FROM python:3.8-slim

RUN apt-get -y update && \
    apt-get -y --no-install-recommends install git wget build-essential python-setuptools python3-dev libjpeg-dev libpng-dev zlib1g-dev && \
    apt install -y --no-install-recommends build-essential && rm -rf /var/lib/apt/lists/*;

RUN mkdir /app

ADD ./ /app
WORKDIR /app

RUN pip install --no-cache-dir -r hub/requirements/plugins.txt && \
    pip install --no-cache-dir -r hub/requirements/tests.txt

RUN pip install --no-cache-dir -e .[all]