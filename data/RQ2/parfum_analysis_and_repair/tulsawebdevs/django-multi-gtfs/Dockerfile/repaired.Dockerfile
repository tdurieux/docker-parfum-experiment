FROM python:3.6
ENV PYTHONUNBUFFERED 1

RUN apt-get update && apt-get install --no-install-recommends -y binutils libproj-dev gdal-bin postgresql-client && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir "django>=1.11,<2.0" psycopg2

RUN mkdir /code
RUN mkdir /feeds

COPY setup.py CHANGELOG.rst README.rst /code/
COPY multigtfs /code/multigtfs
COPY examples/explore /code/examples/explore

WORKDIR /code/examples/explore
RUN pip install --no-cache-dir -r /code/examples/explore/requirements.txt django_extensions django_nose Werkzeug
CMD ["/bin/bash", "/code/examples/explore/docker_run.sh"]
