FROM python:3.7-slim

WORKDIR /app

RUN pip install --no-cache-dir gunicorn["gevent"]

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY run.py .
COPY config.py .
COPY kubemen kubemen

CMD ["gunicorn", "run:app"]
