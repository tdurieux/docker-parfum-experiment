FROM python:3.8

COPY . .
RUN pip install --no-cache-dir "deepdiff<6"
