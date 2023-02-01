FROM python:2.7.18-slim-buster
COPY ./ /app/scripts
RUN pip install --no-cache-dir -r /app/scripts/requirements.txt
