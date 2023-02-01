FROM python:3-alpine3.15
RUN pip install --no-cache-dir opentelemetry-launcher requests pyyaml protobuf==3.20.1
RUN opentelemetry-bootstrap -a install

ADD client.py /app/client.py
CMD ["opentelemetry-instrument", "/app/client.py"]
