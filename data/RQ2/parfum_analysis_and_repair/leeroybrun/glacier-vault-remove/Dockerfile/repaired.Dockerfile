FROM alpine:3.4

RUN apk add --no-cache --update python py-pip
RUN pip install --no-cache-dir boto3

RUN mkdir -p /app

COPY removeVault.py /app/

WORKDIR /app

ENTRYPOINT ["python", "/app/removeVault.py"]
