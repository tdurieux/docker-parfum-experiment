FROM python:3

COPY scripts/kafka/kafka_producer.py .
COPY scripts/kafka/requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

ENTRYPOINT ["python", "kafka_producer.py"]