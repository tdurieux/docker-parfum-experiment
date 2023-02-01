FROM python:3.8-alpine

RUN apk update && \
    apk add --no-cache --update --virtual build-deps gcc libc-dev linux-headers && \
    apk add --no-cache jpeg-dev zlib-dev && \
    apk add --no-cache postgresql-dev && \
    apk add --no-cache netcat-openbsd

WORKDIR /usr/src/app

COPY . .
RUN pip install --no-cache-dir -r requirements.txt
RUN ["python", "manage.py", "collectstatic"]

CMD [ "gunicorn", "web.wsgi", "-b 0.0.0.0:8000" ]

FROM nginx:alpine

COPY docker/proxy/default.conf /etc/nginx/conf.d/
COPY docker/proxy/nginx.conf /etc/nginx/
COPY --from=0 /usr/src/app/static /var/www/static

USER nginx