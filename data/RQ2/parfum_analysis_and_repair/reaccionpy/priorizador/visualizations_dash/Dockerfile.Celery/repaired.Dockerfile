FROM python:3.7

COPY requirements.txt /celery/
RUN pip install --no-cache-dir -r /celery/requirements.txt
COPY * /celery/
RUN rm /celery/requirements.txt
WORKDIR /celery
