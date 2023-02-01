FROM python:2.7
RUN pip install --no-cache-dir uwsgi
RUN apt-get update --fix-missing
RUN apt-get -y --no-install-recommends install python-dev python-lxml libxslt-dev libpq-dev pgadmin3 libtiff5-dev libjpeg62-turbo-dev zlib1g-dev libfreetype6-dev liblcms2-dev libwebp-dev tcl8.6-dev tk8.6-dev python-tk && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libxmlsec1-dev swig && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install nano nginx && rm -rf /var/lib/apt/lists/*;
ENV PYTHONUNBUFFERED=1
WORKDIR /app
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
ENV DATABASE_NAME=frespo
ENV DATABASE_USER=frespo
ENV DATABASE_PASS=frespo
ENV DATABASE_HOST=postgres
ENV DATABASE_PORT=5432
RUN mkdir /uwsgi
COPY docker/bin/* /usr/local/bin/
COPY docker/uwsgi.ini /uwsgi.ini
COPY djangoproject /app
