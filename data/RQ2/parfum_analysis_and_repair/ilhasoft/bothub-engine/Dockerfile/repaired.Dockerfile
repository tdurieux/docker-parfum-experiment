FROM python:3.6-slim

ENV WORKDIR /home/app
WORKDIR $WORKDIR

RUN apt-get update \
 && apt-get install --no-install-recommends --no-install-suggests -y apt-utils \
 && apt-get install --no-install-recommends --no-install-suggests -y gcc bzip2 git curl nginx libpq-dev gettext \
    libgdal-dev python3-cffi python3-gdal vim && rm -rf /var/lib/apt/lists/*;

RUN apt-get install -y --no-install-recommends make && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir -U pip==21.2.2 setuptools==57.4.0
RUN pip install --no-cache-dir poetry==1.1.12
RUN pip install --no-cache-dir gunicorn==19.9.0
RUN pip install --no-cache-dir gevent==1.4.0
RUN pip install --no-cache-dir psycopg2-binary
RUN apt-get install --no-install-recommends -y libjpeg-dev libgpgme-dev linux-libc-dev musl-dev libffi-dev libssl-dev && rm -rf /var/lib/apt/lists/*;
ENV LIBRARY_PATH=/lib:/usr/lib

COPY pyproject.toml pyproject.toml
COPY poetry.lock poetry.lock

RUN poetry config virtualenvs.create false \
  && poetry install --no-interaction --no-ansi

COPY . .

RUN chmod +x ./entrypoint.sh
ENTRYPOINT [ "./entrypoint.sh" ]
