FROM python:3.8.1-alpine
RUN apk update && \
    apk add --no-cache --virtual build-deps gcc python-dev musl-dev && \
    apk add --no-cache postgresql-dev && \
    apk add --no-cache netcat-openbsd

WORKDIR /app/server
COPY requirements.txt /app/server
RUN pip3 install --no-cache-dir -r requirements.txt
#CMD [ "python /app/server/manage.py migrate" ]
