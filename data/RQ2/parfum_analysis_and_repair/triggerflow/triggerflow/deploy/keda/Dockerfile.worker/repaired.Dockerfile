FROM python:3.8-slim

RUN apt-get update \
    && apt-get upgrade -y \
    && rm -rf /var/lib/apt/lists/*

COPY deploy/requirements.txt requirements.txt

RUN pip install --no-cache-dir --upgrade eventlet gunicorn pip setuptools kubernetes six \
    && pip install --no-cache-dir -r requirements.txt

ENV PORT 8080
ENV PYTHONUNBUFFERED TRUE

EXPOSE 8080

ENV APP_HOME /triggerflow
WORKDIR $APP_HOME

ADD triggerflow triggerflow
ADD deploy/keda/bootstrap_worker.py .
ADD deploy/keda/setup.py .

CMD python setup.py && python bootstrap_worker.py