FROM python:3

ADD . /app

RUN pip install --no-cache-dir -r /app/requirements.txt

EXPOSE 5000/tcp
