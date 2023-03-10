# ---- STAGE 1 -----
FROM ubuntu:22.04 AS build-packages

ENV DEBIAN_FRONTEND noninteractive
COPY ./requirements-server.txt ./requirements-server.txt
RUN apt-get update && apt-get install -y --no-install-recommends gcc build-essential python3 python3-pip python3-dev libmariadbclient-dev-compat && rm -rf /var/lib/apt/lists/*
RUN pip install --no-cache-dir --user --no-warn-script-location -r ./requirements-server.txt && pip install --no-cache-dir --no-warn-script-location --user mysqlclient


# ---- STAGE 2 ----
FROM ubuntu:22.04
RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y --no-install-recommends python3 python3-pip curl libmariadbclient-dev-compat \
 && rm -rf /var/lib/apt/lists/ && rm -rf /var/lib/apt/lists/*;

COPY --from=build-packages /root/.local /root/.local
ENV PATH=/root/.local/bin:$PATH

WORKDIR /var/www/oasis
ENV OASIS_MEDIA_ROOT=/shared-fs
ENV OASIS_DEBUG=false
RUN mkdir -p /var/log/oasis

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

COPY ./src/server /var/www/oasis/src/server
COPY ./src/common /var/www/oasis/src/common
COPY ./src/conf /var/www/oasis/src/conf

RUN OASIS_API_SECRET_KEY=supersecret python3 manage.py collectstatic --noinput
ENV OASIS_SERVER_DB_ENGINE django.db.backends.mysql
COPY ./VERSION /var/www/oasis/VERSION

EXPOSE 8000

ENTRYPOINT ["startup"]
CMD ["./asgi/run-asgi.sh"]
