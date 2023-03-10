FROM pennlabs/django-base:9a59b9133a4c82d8391b282a3a39685d7ac6738d

LABEL maintainer="Penn Labs"

# Copy project dependencies
COPY Pipfile* /app/

# Install project dependencies
RUN pipenv install --system

# Copy project files
COPY . /app/

ENV DJANGO_SETTINGS_MODULE Platform.settings.production
ENV SECRET_KEY 'temporary key just to build the docker image'
ENV IDENTITY_RSA_PRIVATE_KEY 'temporary private key just to build the docker image'

# Collect static files
RUN python3 /app/manage.py collectstatic --noinput