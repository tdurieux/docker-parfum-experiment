FROM python:3.6

# Don't write *.pyc files.
ENV PYTHONDONTWRITEBYTECODE 1

ENV PYTHONUNBUFFERED 1

# Requirements have to be pulled and installed here, otherwise caching won't work
COPY ./requirements /requirements

RUN pip install --no-cache-dir -r /requirements/testing.txt

RUN groupadd -r django && useradd -r -g django django
COPY . /app
RUN chown -R django /app

COPY ./docker/django/entrypoint.sh /entrypoint.sh
RUN sed -i 's/\r//' /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /app

ENTRYPOINT ["/entrypoint.sh"]
