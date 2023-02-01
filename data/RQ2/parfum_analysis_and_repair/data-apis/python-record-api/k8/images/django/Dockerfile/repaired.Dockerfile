ARG FROM
FROM ${FROM}

WORKDIR /usr/src/app

# https://github.com/django/django-docker-box/blob/master/Dockerfile#L4
RUN apt-get update && \
    apt-get -y install --no-install-recommends \
        libmemcached-dev \
        build-essential \
        libsqlite3-mod-spatialite binutils libproj-dev gdal-bin libgdal20 libgeoip1 \
        libpq-dev \
        unzip libaio1 \
        libenchant1c2a \
        gettext \
        wget \
    && apt-get clean && rm -rf /var/lib/apt/lists/*;

# https://docs.djangoproject.com/en/dev/internals/contributing/writing-code/unit-tests/#quickstart
RUN git clone \
    --branch 3.0.8 \
    --depth 1 \
    git://github.com/django/django.git \
    .

WORKDIR /usr/src/app/tests
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --no-cache-dir \
    -e .. \
    -r requirements/py3.txt \
    -r requirements/postgre

RUN python -c "import django"
ENV PYTHON_RECORD_API_FROM_MODULES=django
CMD sh -c 'python runtests.py || exit 0'