FROM python:3.7-alpine

RUN pip install --no-cache-dir requests

ADD solve.py solve.py
CMD python solve.py

