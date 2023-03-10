FROM python:3.8

WORKDIR /var/www/oasis

ENV OASIS_MEDIA_ROOT=/shared-fs
ENV OASIS_DEBUG=false

RUN mkdir -p /var/log/oasis

RUN apt-get update && apt-get install -y --no-install-recommends vim libmariadbclient-dev-compat libspatialindex-dev && rm -rf /var/lib/apt/lists/*
COPY ./requirements-server.txt ./requirements.txt
RUN pip install --no-cache-dir -r ./requirements.txt
RUN pip install --no-cache-dir mysqlclient

# Copy startup script + server config
COPY ./src/startup_server.sh /usr/local/bin/startup
COPY ./src/utils/wait-for-it.sh /usr/local/bin/wait-for-it
COPY ./src/utils/wait-for-server.sh /usr/local/bin/wait-for-server
RUN chmod +x /usr/local/bin/startup /usr/local/bin/wait-for-it

COPY ./conf.ini ./
COPY ./uwsgi ./uwsgi
RUN chmod +x ./uwsgi/run-uwsgi.sh
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
CMD ["./uwsgi/run-uwsgi.sh"]
