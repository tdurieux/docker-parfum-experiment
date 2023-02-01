# Production Dockerfile for Django app

FROM python:{{ cookiecutter.python_version }}-alpine3.8 as base

ENV DJANGO_PRODUCTION_MODE 1

# Create a directory for the logs
RUN mkdir -p /var/log/{{cookiecutter.repo_name}}

COPY ./wait-for-it.sh /usr/bin/

# Install bash, libpq{% if cookiecutter.include_cms == 'yes' %}, libjpeg-turbo{% endif %} and gettext
# Bash is required to support `wait-for-it.sh` script, should not add too much to docker image
RUN apk add --no-cache bash gettext libpq{% if cookiecutter.include_cms == 'yes' %} libjpeg-turbo{% endif %}

# Install build dependencies and mark them as virtual packages so they could be removed together
RUN apk add --no-cache --virtual .build-deps \
    ca-certificates alpine-sdk postgresql-dev python3-dev linux-headers musl-dev \
    libffi-dev libxml2-dev libxslt-dev jpeg-dev zlib-dev

# Copy Python requirements dir and Install requirements
RUN pip install -U pipenv==2018.11.26 pip setuptools wheel

COPY Pipfile /
COPY Pipfile.lock /

# Install all dependencies from Pipfile.lock file
RUN pipenv install --system --ignore-pipfile

# Find all file objects containing name `test` or compiled python files and remove them
# Find all runtime dependencies that are marked as needed by scanelf
# scanelf is utility to show ELF data for binary objects
# For more info: https://wiki.gentoo.org/wiki/Hardened/PaX_Utilities#The_scanelf_application
# Finally re-install missing run-dependencies
RUN find /usr/local \
        \( -type d -a -name test -o -name tests \) \
        -o \( -type f -a -name '*.pyc' -o -name '*.pyo' \) \
        -exec rm -rf '{}' + \
  && runDeps="$( \
        scanelf --needed --nobanner --recursive /usr/local \
                | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
                | sort -u \
                | xargs -r apk info --installed \
                | sort -u \
    )" \
  && apk add --virtual .rundeps $runDeps

# Remove build dependencies
RUN apk del .build-deps

# Copy code
COPY ./{{cookiecutter.repo_name}} /app

# Set the default directory where CMD will execute
WORKDIR /app

# Compile translations to .mo files
# RUN python manage.py compilemessages

# Based on Node 10.x LTS image
FROM node:{% if cookiecutter.node_version == '10' %}10.15.1{% else %}{{ cookiecutter.node_version }}{% endif %}-alpine as node_builder

# Set the default directory where CMD will execute
WORKDIR /app

# Install node build dependencies
# Not removing them as not to break fabfile logic for exporting assets
# These can be removed with: "RUN apk del .build-deps"
RUN apk add --no-cache --virtual .build-deps build-base python

# Copy some utility files
COPY ./{{ cookiecutter.repo_name }}/.babelrc .
COPY ./{{ cookiecutter.repo_name }}/.eslintrc .
COPY ./{{ cookiecutter.repo_name }}/.eslintignore .

# Install node requirements
COPY ./{{ cookiecutter.repo_name }}/package.json .
COPY ./{{ cookiecutter.repo_name }}/yarn.lock ./

# Install node dependencies
RUN yarn install --frozen-lockfile

# Copy app assets
COPY ./{{ cookiecutter.repo_name }}/app /app/app
COPY ./{{ cookiecutter.repo_name }}/static /app/static

# Build node stuff
RUN yarn build

# Resume Django build
FROM base

# Copy all from node image
COPY --from=node_builder /app/app/build /app/app/build
COPY --from=node_builder /app/app/webpack-stats.json /app/app/webpack-stats.json

# Run Gunicorn by default
CMD gunicorn {{ cookiecutter.repo_name }}.wsgi:application --workers 2 --bind :80
