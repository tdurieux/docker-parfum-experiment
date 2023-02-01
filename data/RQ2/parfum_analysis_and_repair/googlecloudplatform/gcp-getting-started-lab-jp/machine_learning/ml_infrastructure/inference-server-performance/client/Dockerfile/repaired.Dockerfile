FROM gcr.io/YOUR-PROJECT-ID/tensorrtserver_client

RUN pip install --no-cache-dir --upgrade locust

COPY locust locust
COPY data data
