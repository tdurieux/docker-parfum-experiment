# ---- STAGE 1 -----
FROM python:3.9.7-alpine3.14 AS build-packages

RUN apk update && apk add --no-cache curl gcc mariadb-dev bash build-base musl-dev linux-headers libressl-dev libffi-dev postgresql-dev libpq

ENV CRYPTOGRAPHY_DONT_BUILD_RUST=1
COPY ./requirements-server.txt ./requirements-server.txt
RUN pip install --no-cache-dir --user --no-warn-script-location -r ./requirements-server.txt && pip install --no-cache-dir --no-warn-script-location --user mysqlclient


# ---- STAGE 2 ----
FROM python:3.9.7-alpine3.14
RUN apk update \
 && apk add --no-cache mariadb-dev libpq bash curl \
 && apk upgrade --available

# Note general package upgrade can be problematic for consistent builds, but safer in terms of security


COPY --from=build-packages /root/.local /root/.local
ENV PATH=/root/.local/bin:$PATH

WORKDIR /var/www/oasis
ENV OASIS_MEDIA_ROOT=/shared-fs
ENV OASIS_DEBUG=false
RUN mkdir -p /var/log/oasis

# Copy startup script + server config
COPY ./src/startup_server.sh /usr/local/bin/startup
COPY ./src/utils/wait-for-it.sh /usr/local/bin/wait-for-it
COPY ./src/utils/wait-for-server.sh /usr/local/bin/wait-for-server
RUN chmod +x /usr/local/bin/startup /usr/local/bin/wait-for-it

COPY ./asgi ./asgi
RUN chmod +x ./asgi/run-asgi.sh

COPY ./conf.ini ./
COPY manage.py .
COPY ./src/utils/set_default_user.py .
COPY ./src/utils/server_bashrc /root/.bashrc

COPY ./src/ ./src
COPY ./src/server /var/www/oasis/src/server
COPY ./src/common /var/www/oasis/src/common
COPY ./src/conf /var/www/oasis/src/conf
COPY ./VERSION /var/www/oasis/VERSION

COPY ./model_resource.json /var/www/oasis/src/server/static/model_resource.json
RUN OASIS_API_SECRET_KEY=supersecret python manage.py collectstatic --noinput
ENV OASIS_SERVER_DB_ENGINE django.db.backends.mysql

EXPOSE 8000

ENTRYPOINT ["startup"]
CMD ["./asgi/run-asgi.sh"]
