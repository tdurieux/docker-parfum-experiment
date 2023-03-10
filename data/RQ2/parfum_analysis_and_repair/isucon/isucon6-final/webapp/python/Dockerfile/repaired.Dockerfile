FROM python:2.7.12-alpine

WORKDIR /var/www

# キャッシュ効率を上げるためにrequirements.txtだけ先にcopyしてインストールする
COPY ./requirements.freeze /var/www

RUN \
  apk update && \
  apk add --no-cache mariadb-client-libs && \
  apk add --no-cache --virtual=build-dependencies gcc mariadb-dev musl-dev && \
  pip install --no-cache-dir -r requirements.freeze && \
  apk del build-dependencies

COPY . /var/www

EXPOSE 80

CMD ["gunicorn", "-w", "32", "-b", ":80", "app:app"]
