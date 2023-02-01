FROM python:3.7-alpine

RUN pip install --no-cache-dir requests

WORKDIR /solution
ADD solve.py .

CMD python solve.py
