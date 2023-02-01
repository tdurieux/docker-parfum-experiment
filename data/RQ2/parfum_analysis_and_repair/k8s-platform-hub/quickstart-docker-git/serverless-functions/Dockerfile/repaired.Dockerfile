FROM python:2.7-alpine

WORKDIR /deploy

COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt

COPY deploy.py /deploy/deploy.py

COPY config.json /deploy/config.json

COPY functions /deploy/functions

CMD ["python", "deploy.py"]