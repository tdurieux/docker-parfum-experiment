FROM python:3.7-alpine

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY ./gricleaner.py .

ENTRYPOINT ["./gricleaner.py"]
