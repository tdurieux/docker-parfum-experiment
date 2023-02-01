FROM python:3.8-buster

WORKDIR /app

RUN apt-get update && apt-get install --no-install-recommends -y python3-dev build-essential libpq-dev && rm -rf /var/lib/apt/lists/*;

ADD requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

ADD app.py .

ENTRYPOINT ["python", "app.py"]
