#########################################
# The python3 base for flask boilerplate (front-end)

FROM pdonorio/py3api
MAINTAINER "Paolo D'Onorio De Meo <p.donoriodemeo@gmail.com>"

RUN apt-get update && apt-get install --no-install-recommends -y -q \
    # Gevent dev
    libffi-dev \
    # Postgres dev
    # libpq-dev \
    && apt-get clean autoclean && apt-get autoremove -y && \
    rm -rf /var/lib/cache /var/lib/log && rm -rf /var/lib/apt/lists/*;

# Connection via sqlalchemy
RUN pip3 install --no-cache-dir --upgrade \
    sqlalchemy psycopg2 Werkzeug Flask-SQLAlchemy \
    flask_table Flask-WTF WTForms-Alchemy \

    meinheld tornado \

    setuptools cffi tox 'cython>=0.23.4' \
    git+git://github.com/gevent/gevent.git#egg=gevent

VOLUME /data
WORKDIR /data
