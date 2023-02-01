FROM python:3.6
RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir pika
CMD ["python3"]
