FROM python:3.8-rc-slim

COPY app.py /app/app.py
COPY routes /app/routes
COPY static /app/static
COPY requirements.txt /app/requirements.txt

RUN pip install --no-cache-dir -r /app/requirements.txt

WORKDIR /app

EXPOSE 5000