FROM python:3.7.1-alpine3.7

RUN mkdir -p /app
WORKDIR /app

COPY requirements.txt requirements.txt

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["faust", "-A", "consumer", "worker", "-l", "info"]
