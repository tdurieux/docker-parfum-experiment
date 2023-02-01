FROM python:3

RUN apt-get update && apt-get install -y poppler-utils libreoffice --no-install-recommends && rm -rf /var/lib/apt/lists/*;

COPY requirements.txt /app/requirements.txt

RUN pip install --no-cache-dir -r /app/requirements.txt

COPY script.py /app/script.py

VOLUME ["/data"]

WORKDIR /data

ENTRYPOINT ["python", "/app/script.py"]
