FROM tiangolo/uwsgi-nginx-flask:python3.8
# Note it doesn't support Python 3.9 yet.

RUN set -ex && pip install --no-cache-dir pipenv --upgrade

COPY Pipfile* /app/

RUN set -ex && pipenv install --deploy --system

COPY uwsgi.conf /etc/nginx/conf.d/
COPY uwsgi.ini .
COPY prestart.sh .
COPY clasificahumor clasificahumor
