FROM python:3.6-alpine

COPY requirements.txt /app/requirements.txt
RUN pip --no-cache-dir install -r /app/requirements.txt

RUN addgroup -g 9999 emustrings && \
    adduser -D -h /app -u 9999 -G emustrings emustrings && \
    mkdir -p /app/results/analysis && \
    mkdir -p /app/results/emulation && \
    chown -R emustrings:emustrings /app
USER emustrings

COPY daemon.py /app/daemon.py
COPY worker.sh /app/worker.sh
COPY emustrings /app/emustrings

WORKDIR /app/
ENTRYPOINT ./worker.sh