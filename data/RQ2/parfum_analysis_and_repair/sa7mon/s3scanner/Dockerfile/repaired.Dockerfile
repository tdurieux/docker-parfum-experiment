FROM python:3.8-alpine
COPY . /app
WORKDIR /app
RUN pip install --no-cache-dir boto3
RUN pip install --no-cache-dir .
ENTRYPOINT ["python", "-m", "S3Scanner"]