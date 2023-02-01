FROM python:3.8-slim-buster                                        

ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1
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

# Requirements are installed here to ensure they will be cached.
COPY ./requirements /requirements
RUN pip install --no-cache-dir -r /requirements/local.txt

COPY ./docker/local/django/start.sh /start.sh
RUN sed -i 's/\r$//g' /start.sh
RUN chmod +x /start.sh

WORKDIR /app
