FROM edoburu/django-base-images:py36-stretch-build-onbuild AS build-image

# Node builder
FROM node:9-stretch as frontend-build
RUN mkdir -p /app/src
WORKDIR /app/src
COPY src/package.json src/package-lock.json* /app/src/
RUN npm install && npm cache clean --force;
COPY src/gulpfile.js /app/src/
COPY src/frontend/ /app/src/frontend/
RUN npm run gulp

# Start runtime container
FROM edoburu/django-base-images:py36-stretch-runtime-onbuild
ENV DJANGO_SETTINGS_MODULE={{ project_name }}.settings.docker \
    UWSGI_MODULE={{ project_name }}.wsgi.docker:application

HEALTHCHECK --interval=5m --timeout=3s CMD curl -f http://localhost:8080/api/health/ || exit 1

COPY --from=frontend-build /app/src/frontend/static /app/src/frontend/static

# Collect static files as root, with gzipped files for uwsgi to serve
# Add CACHE folder for django-compressor to write into
RUN manage.py compilemessages && \
    manage.py collectstatic --noinput
    #whitenoise does this;
    #gzip --keep --best --force --recursive /app/web/static/ && \

COPY deployment/docker/uwsgi-local.ini /usr/local/etc/uwsgi-local.ini

# Tag the docker image
ARG GIT_VERSION
LABEL git-version=$GIT_VERSION
RUN echo $GIT_VERSION > .docker-git-version

# Reduce default permissions
USER app
