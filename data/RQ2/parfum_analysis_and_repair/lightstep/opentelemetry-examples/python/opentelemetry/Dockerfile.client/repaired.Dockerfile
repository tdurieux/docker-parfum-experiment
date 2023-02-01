FROM python:3-alpine3.15

RUN mkdir /app
WORKDIR /app
ADD requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

RUN opentelemetry-bootstrap -a install

ADD *.py ./
CMD ["opentelemetry-instrument", "/app/client.py"]
