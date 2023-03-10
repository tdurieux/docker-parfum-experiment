FROM python:3.6

RUN apt-get update && apt-get upgrade -y \
        && rm -rf /var/lib/apt/lists/*

COPY deploy/requirements.txt requirements.txt

RUN pip install --no-cache-dir --upgrade eventlet gunicorn pip setuptools kubernetes six \
    && pip install --no-cache-dir -r requirements.txt

ENV PORT 8080
ENV PYTHONUNBUFFERED TRUE

ENV APP_HOME /triggerflow
WORKDIR $APP_HOME

ADD deploy/knative/controllerproxy.py .
ADD triggerflow/service/databases/redis_db.py .
ADD triggerflow/service/databases/cloudant_db.py .
ADD config.yaml .

CMD exec gunicorn --workers 1 --worker-class eventlet --bind :$PORT controllerproxy:app