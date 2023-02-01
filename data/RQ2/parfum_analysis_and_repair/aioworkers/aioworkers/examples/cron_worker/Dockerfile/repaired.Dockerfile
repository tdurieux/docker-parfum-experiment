FROM python:3.6-alpine

WORKDIR /worker

COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY config.yaml worker.py /worker/

CMD python -m aioworkers.cli -c config.yaml -l info