# VideoFront, a FUN LTI video provider
#
# Nota bene:
#
# this container expects two volumes for statics and media files (that will be
# served by nginx):
#
# * /data/media
# * /data/static
#
# Once mounted, you will need to collect static files via the eponym django
# admin command:
#
#     python ./manage.py collectstatic
#

# ---- base image to inherit from ----
FROM python:3.6-stretch as base

# ---- back-end builder image ----
FROM base as back-builder

WORKDIR /install

COPY setup.cfg /setup.cfg

RUN python -c "import configparser; c = configparser.ConfigParser(); c.read('/setup.cfg'); \
    print(c['options']['install_requires'] + c['options.extras_require']['aws'])" | \
    xargs pip install --prefix=/install

# ---- final application image ----
FROM base

# Copy installed python dependencies
COPY --from=back-builder /install /usr/local

# Copy the VideoFront application (see .dockerignore)
COPY . /app/

WORKDIR /app

# Gunicorn
RUN mkdir -p /usr/local/etc/gunicorn
COPY docker/files/usr/local/etc/gunicorn/videofront.py /usr/local/etc/gunicorn/videofront.py

# Give the "root" group the same permissions as the "root" user on /etc/passwd
# to allow a user belonging to the root group to add new users; typically the
# docker user (see entrypoint).
RUN chmod g=u /etc/passwd

# We wrap commands run in this container by the following entrypoint that
# creates a user on-the-fly with the container user ID (see USER) and root group
# ID.
ENTRYPOINT [ "/app/bin/entrypoint" ]

# The default command runs gunicorn WSGI server
CMD gunicorn -c /usr/local/etc/gunicorn/videofront.py videofront.wsgi:application

# Un-privileged user running the application