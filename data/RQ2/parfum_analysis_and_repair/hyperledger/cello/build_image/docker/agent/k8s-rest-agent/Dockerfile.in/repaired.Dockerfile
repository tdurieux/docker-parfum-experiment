FROM python:3.8

COPY src/agent/k8s-rest-agent/requirements.txt /
COPY src/agent/k8s-rest-agent/pip /root/.pip

RUN pip install --no-cache-dir -r /requirements.txt

COPY src/agent/k8s-rest-agent/src /var/www/server
COPY src/agent/k8s-rest-agent/entrypoint.sh /
COPY src/agent/k8s-rest-agent/uwsgi/server.ini /etc/uwsgi/apps-enabled/
RUN mkdir /var/log/supervisor

ENV WEBROOT /
ENV WEB_CONCURRENCY 10
ENV DEBUG False
ENV UWSGI_WORKERS 1
ENV UWSGI_PROCESSES 1
ENV UWSGI_OFFLOAD_THREADS 10
ENV UWSGI_MODULE server.wsgi:application

WORKDIR /var/www/server
RUN python manage.py collectstatic --noinput

CMD bash /entrypoint.sh
