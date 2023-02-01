FROM python:3.8-slim

WORKDIR /usr/src/app

COPY . .

RUN pip install --no-cache-dir -r ./deploy/requirements_clickhouse.txt

CMD ["python", "consumer.py"]

