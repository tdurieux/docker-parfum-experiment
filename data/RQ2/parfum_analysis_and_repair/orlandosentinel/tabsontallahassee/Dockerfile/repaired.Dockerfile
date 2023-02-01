FROM python:3.5
ENV PYTHONUNBUFFERED 1

RUN apt-get update -y && apt-get install --no-install-recommends build-essential git python-pycurl python-boto libpq-dev unzip gdal-bin poppler-utils -y && rm -rf /var/lib/apt/lists/*;
RUN pyvenv /virt/
RUN mkdir /code
WORKDIR /code
ADD requirements.txt /code/
RUN /virt/bin/pip install -r requirements.txt
ADD . /code/
ENV DATABASE_URL postgis://tot:tot@db/opencivicdata
