FROM python:3.8

# Copy the application code to the container:
RUN mkdir /code/
WORKDIR /code/
ADD . /code/

# Install all build deps:
RUN set -ex \
    && apt-get update \
    && apt-get install --no-install-recommends -y \
        gcc \
        gettext \
        libjpeg62 \
        libjpeg62-turbo-dev \
        libpq-dev \
        make \
        postgresql-client \
    && pip install --no-cache-dir -r /code/requirements.txt && rm -rf /var/lib/apt/lists/*;

# expose port
EXPOSE 8000

# Docker entrypoint:
ENV DJANGO_MANAGEPY_MIGRATE=on \
    DJANGO_MANAGEPY_COLLECTSTATIC=on \
    DJANGO_MANAGEPY_UPDATEINDEX=on
ENTRYPOINT ["/code/docker-entrypoint.sh"]

# Start python runserver:
CMD ["python", "./manage.py", "runserver", "0.0.0.0:8000"]
