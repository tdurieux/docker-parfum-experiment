FROM python:3.6

COPY src/core /usr/tortuga/src/core

RUN pip install --no-cache-dir -e /usr/tortuga/src/core
