FROM python:2.7.12-alpine

WORKDIR /var/www

# キャッシュ効率を上げるためにrequirements.txtだけ先にcopyしてインストールする
COPY ./requirements.txt /var/www

RUN \
  apk update && \
  apk add --no-cache mariadb-client-libs && \
  apk add --no-cache --virtual=build-dependencies gcc mariadb-dev musl-dev && \
  pip install --no-cache-dir -r requirements.txt && \
  apk del build-dependencies

EXPOSE 80

ENV FLASK_APP=app.py

CMD ["flask", "run", "--host=0.0.0.0", "--port=80"]
