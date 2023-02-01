FROM python:3

ADD get-data.py /

RUN pip install --no-cache-dir azure-cosmos

CMD sleep infinity