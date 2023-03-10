FROM python:3.6

WORKDIR /opt/nomad/

RUN apt-get update \
 && apt-get -y --no-install-recommends install \
    libpq-dev \
    postgresql-client \
    postgresql-client-common \
    binutils \
    libproj-dev \
    gdal-bin \
    python-gdal \
 && apt-get clean \
 && apt-get autoremove && rm -rf /var/lib/apt/lists/*;

RUN pip install -U --no-cache-dir pipenv

ADD Pipfile .
ADD Pipfile.lock .
RUN pipenv install --system --deploy --dev

ADD . .

EXPOSE 5000
