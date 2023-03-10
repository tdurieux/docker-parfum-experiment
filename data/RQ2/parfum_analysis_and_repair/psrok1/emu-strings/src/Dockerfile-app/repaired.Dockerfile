FROM node:10 AS build

COPY web /app/web

RUN groupadd -g 9999 emustrings && \
    useradd -r -d /app -u 9999 -g emustrings emustrings && \
    chown -R emustrings:emustrings /app
USER emustrings

RUN cd /app/web \
    && npm install \
    && npm run build \
    && npm cache clean --force

FROM tiangolo/uwsgi-nginx-flask:python3.6-alpine3.8

COPY requirements.txt /app/requirements.txt
RUN pip --no-cache-dir install -r /app/requirements.txt
COPY --from=build /app/web/build /app/build

RUN addgroup -g 9999 emustrings && \
    adduser -D -h /app -u 9999 -G emustrings emustrings && \
    mkdir -p /app/results/analysis && \
    mkdir -p /app/results/emulation && \
    chown -R emustrings:emustrings /app
USER emustrings

COPY app.py /app/app.py
COPY uwsgi.ini /app/uwsgi.ini
COPY emustrings /app/emustrings

USER root