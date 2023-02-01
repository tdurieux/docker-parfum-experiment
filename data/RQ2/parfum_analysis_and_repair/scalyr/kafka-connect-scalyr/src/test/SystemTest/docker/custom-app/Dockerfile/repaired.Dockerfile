# Create simulated custom application image that sends custom application logs to Kafka
FROM python:3.7-slim

COPY requirements.txt /tmp/requirements.txt
RUN pip3 install --no-cache-dir -U -r /tmp/requirements.txt

COPY producer.py /root
CMD ["python", "/root/producer.py"]
