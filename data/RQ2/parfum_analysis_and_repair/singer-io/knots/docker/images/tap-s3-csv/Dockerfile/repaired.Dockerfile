FROM python:3.6-alpine
ARG version
RUN pip install --no-cache-dir tap-s3-csv==${version}
WORKDIR /app
CMD ["tap-s3-csv"]
