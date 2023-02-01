FROM python:3.6-alpine

COPY requirements.txt /requirements.txt
RUN pip install -r /requirements.txt

COPY . /app
RUN adduser -S rsd_backend
USER rsd_backend

WORKDIR /app

STOPSIGNAL SIGINT

CMD gunicorn --preload --workers 3 --max-requests 10 --timeout 15 --bind 0.0.0.0:5001 --access-logfile - --error-logfile - entry:application
EXPOSE 5001
