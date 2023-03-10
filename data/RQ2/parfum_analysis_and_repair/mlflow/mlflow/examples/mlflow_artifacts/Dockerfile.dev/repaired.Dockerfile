FROM python:3.7

WORKDIR /app

# Install packages requied to interact with PostgreSQL and MinIO
RUN pip install --no-cache-dir psycopg2 boto3
# Install the dev version of mlflow via wheel
COPY dist ./dist
RUN pip install --no-cache-dir dist/mlflow-*.whl
