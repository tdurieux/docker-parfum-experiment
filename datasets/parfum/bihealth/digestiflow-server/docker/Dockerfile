FROM python:3.8-buster

MAINTAINER Manuel Holtgrewe <manuel.holtgrewe@bih-charite.de>
LABEL org.opencontainers.image.source https://github.com/bihealth/digestiflow-server

ARG app_git_url=https://github.com/bihealth/digestiflow-server.git
ARG app_git_tag
ARG app_git_depth=1

ENV DEBIAN_FRONTEND noninteractive
ENV CUSTOM_STATIC_DIR /usr/src/app/local-static

## Add the wait script to the image
ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.7.3/wait /usr/local/bin/wait
RUN chmod +x /usr/local/bin/wait

# Copy source code into Docker image.
RUN mkdir -p /usr/src
RUN git clone --depth $app_git_depth --branch $app_git_tag $app_git_url /usr/src/app
RUN ls -lh

# Install system dependencies.
RUN apt-get update && \
    apt-get install -y \
        apt-utils \
        gcc \
        ldap-utils \
        libldap2-dev \
        libsasl2-dev \
        make \
        postgresql-client \
        wget

# Install Python dependencies.
RUN cd /usr/src/app && \
    pip install --no-cache-dir -r requirements/production.txt && \
    pip install --no-cache-dir -r requirements/ldap.txt

# Build sphinx manual.
RUN cd /usr/src/app/docs_manual && \
    make clean html

# Download files from CDN.
RUN mkdir -p /usr/src/app/local-static/local/css && \
    mkdir -p /usr/src/app/local-static/local/js && \
    cd /usr/src/app/local-static/local/css && \
    wget \
        https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/css/bootstrap.min.css \
        https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.13.18/css/bootstrap-select.min.css \
        https://cdn.datatables.net/1.10.24/css/dataTables.jqueryui.min.css \
        https://cdn.jsdelivr.net/npm/bootstrap4-tagsinput@4.1.3/tagsinput.css && \
    \
    cd /usr/src/app/local-static/local/js && \
    wget \
        https://code.jquery.com/jquery-3.5.1.min.js \
        https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/js/bootstrap.bundle.min.js \
        https://cdnjs.cloudflare.com/ajax/libs/tether/1.4.4/js/tether.min.js \
        https://cdnjs.cloudflare.com/ajax/libs/shepherd/1.8.1/js/shepherd.min.js \
        https://cdnjs.cloudflare.com/ajax/libs/clipboard.js/2.0.0/clipboard.min.js \
        https://browser.sentry-cdn.com/6.2.5/bundle.tracing.min.js \
        https://cdn.datatables.net/1.10.24/js/jquery.dataTables.min.js \
        https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.13.18/js/bootstrap-select.min.js \
        https://cdn.jsdelivr.net/npm/bootstrap4-tagsinput@4.1.3/tagsinput.js \
        https://cdnjs.cloudflare.com/ajax/libs/jsrender/1.0.11/jsrender.min.js \
        https://cdn.plot.ly/plotly-1.54.5.min.js \
        https://cdnjs.cloudflare.com/ajax/libs/axios/0.21.1/axios.min.js \
        https://cdnjs.cloudflare.com/ajax/libs/google-palette/1.1.0/palette.min.js \
        https://cdnjs.cloudflare.com/ajax/libs/lodash.js/4.17.21/lodash.min.js

# Get icons
RUN cd /usr/src/app && \
    DJANGO_SECRET_KEY=for-build-only \
    DJANGO_SETTINGS_MODULE=config.settings.production \
    DATABASE_URL=postgres://sodar:sodar@fake/sodar \
    python manage.py geticons

# Prepare static files
RUN cd /usr/src/app && \
    DJANGO_SECRET_KEY=for-build-only \
    DJANGO_SETTINGS_MODULE=config.settings.production \
    DATABASE_URL=postgres://digestiflow:digestiflow@fake/digestiflow \
    python manage.py collectstatic --no-input

# Define the entry point.
COPY docker-entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/docker-entrypoint.sh && \
    ln -s /usr/local/bin/docker-entrypoint.sh / # backwards compat
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["wsgi"]
EXPOSE 8080/tcp
