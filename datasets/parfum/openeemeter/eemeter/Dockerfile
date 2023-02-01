FROM python:3.6.6

RUN set -ex && pip install pip pipenv --upgrade

# sphinxcontrib-spelling dependency
RUN apt-get update \
  && apt-get install -yqq libenchant-dev

COPY Pipfile Pipfile
COPY Pipfile.lock Pipfile.lock
RUN set -ex && pipenv install --system --deploy --dev
ENV PYTHONPATH=/usr/local/bin:/app

COPY setup.py README.rst /app/
COPY eemeter/ /app/eemeter/
RUN set -ex && pip install -e /app
RUN set -ex && cd /usr/local/lib/ && python /app/setup.py develop

WORKDIR /app
