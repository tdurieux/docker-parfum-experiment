FROM python:3-alpine

LABEL "name"="Renovate Helm Releases"
LABEL "maintainer"="Devin Buhl <devin.kray@gmail.com>, Bernd Schorgers <me@bjw-s.dev>"

LABEL "com.github.actions.name"="Renovate Helm Releases"
LABEL "com.github.actions.description"="Creates Renovate annotations in Flux2 Helm Releases"
LABEL "com.github.actions.icon"="send"
LABEL "com.github.actions.color"="blue"

COPY requirements.txt /app/requirements.txt

RUN \
  apk add --no-cache bash \
  && pip install --no-cache-dir -r /app/requirements.txt

COPY renovate.py /app/renovate.py

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
