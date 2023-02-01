FROM python:3.7-slim-stretch

RUN apt-get update && apt-get install --no-install-recommends -y git python3-dev gcc \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

RUN pip install --no-cache-dir --upgrade pip

RUN pip install --no-cache-dir -r requirements.txt --upgrade

COPY app app/

EXPOSE 5555

CMD ["python", "app/server.py"]
