FROM python:3.7.4-slim

RUN mkdir -p /nfv_mon

WORKDIR /nfv_mon
COPY katana-nfv_mon/. .

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

ENV PYTHONPATH=.

CMD [ "python", katana/exporter.py ]