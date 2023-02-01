FROM python:3-slim

WORKDIR /
ENV SUCCESS_RATE=80 \
    FLASK_APP=app.py
STOPSIGNAL SIGINT
CMD ["python", "/app.py"]
RUN pip install --no-cache-dir flask prometheus_client
COPY app.py /app.py
