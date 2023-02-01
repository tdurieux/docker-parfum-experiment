FROM python:3
WORKDIR /opt
RUN pip install --no-cache-dir psycopg2==2.9.3
# COPY . .

