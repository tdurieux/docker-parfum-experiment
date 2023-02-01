FROM python:3.8-alpine

RUN apk update && \
    apk add --no-cache --update --virtual build-deps gcc libc-dev linux-headers && \
    apk add --no-cache jpeg-dev zlib-dev && \
    apk add --no-cache postgresql-dev && \
    apk add --no-cache netcat-openbsd

RUN apk add --no-cache --update nodejs-current npm

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

WORKDIR /usr/src/app

COPY . .

RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir gunicorn

CMD [ "gunicorn", "web.wsgi", "-b 0.0.0.0:8000" ]