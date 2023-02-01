# Dockerfile for the rangl environment server
FROM python:3.9-slim-buster

WORKDIR /service
COPY rangl/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . /service
RUN pip install --no-cache-dir .
RUN pip list

CMD ["python", "rangl/server.py"]