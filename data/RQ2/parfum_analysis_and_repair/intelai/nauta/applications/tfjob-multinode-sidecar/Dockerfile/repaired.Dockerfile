FROM python:3.6.7-slim

WORKDIR /app

ADD requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

ADD main.py .

ENTRYPOINT python3.6 -u main.py
