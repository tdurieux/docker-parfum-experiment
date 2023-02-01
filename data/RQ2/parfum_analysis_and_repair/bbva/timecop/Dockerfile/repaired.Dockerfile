FROM tiangolo/uwsgi-nginx-flask:python3.6

COPY ./ /app
COPY ./requirements.txt /tmp/
COPY ./config/timeout.conf /etc/nginx/conf.d/

RUN pip install --no-cache-dir mxnet==1.4.1 gluonts && apt-get update && apt-get install --no-install-recommends -y redis-server python3-celery python-celery-common python3-redis && rm -rf /var/lib/apt/lists/* && pip3 install --no-cache-dir numpy pandas && pip3 install --no-cache-dir --requirement /tmp/requirements.txt && pip3 install --no-cache-dir fbprophet && chmod -R g=u /etc/passwd /app && pip install --no-cache-dir --upgrade pyflux && pip install --no-cache-dir --upgrade numpy && pip install --no-cache-dir nbeats-keras && pip install --no-cache-dir -U tensorflow && rm -fr /root/.cache/pip && service redis-server start
