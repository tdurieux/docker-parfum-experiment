FROM python:3.8.2-buster
RUN pip install --no-cache-dir redis
COPY ./worker.py /worker.py
COPY ./rediswq.py /rediswq.py

CMD  python worker.py
