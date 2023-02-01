FROM alpine:3.10

RUN apk add --no-cache python3 py-pip && \
python3 -m ensurepip && \
 pip install --no-cache-dir --upgrade pip && \
 pip install --no-cache-dir flask && \
 pip install --no-cache-dir requests

WORKDIR /app
COPY ./app/ /app/

CMD ["python", "main.py"]
