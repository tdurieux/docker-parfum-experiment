FROM python:3.8-slim-buster

ENV PYTHONUNBUFFERED 1

RUN apt-get update \
  # psycopg2 dependencies \
  && apt-get install --no-install-recommends -y gcc build-essential python3-dev \
  && apt-get install --no-install-recommends -y libpq-dev \
  # CFFI dependencies
  && apt-get install --no-install-recommends -y libffi-dev python-cffi \
  # Translations dependencies
  && apt-get install --no-install-recommends -y gettext \
  # https://docs.djangoproject.com/en/dev/ref/django-admin/#dbshell
  && apt-get install --no-install-recommends -y postgresql-client && rm -rf /var/lib/apt/lists/*;


RUN addgroup --system django && adduser --system --ingroup  django django

# Requirements are installed here to ensure they will be cached.
COPY ./requirements /requirements
RUN pip install --no-cache-dir -r /requirements/production.txt \
  && rm -rf /requirements

COPY ./docker/production/django/start-web.sh /start-web.sh
RUN chmod +x /start-web.sh
RUN chown django /start-web.sh
COPY . /app

RUN chown -R django /app

USER django

WORKDIR /app

CMD ["/start-web.sh"]
