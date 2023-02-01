FROM python:3.7-alpine

COPY amazon_price.py /app/
COPY requirements.txt /tmp
RUN pip3 install --no-cache-dir -r /tmp/requirements.txt

WORKDIR /app
CMD ["python3", "amazon_price.py"]