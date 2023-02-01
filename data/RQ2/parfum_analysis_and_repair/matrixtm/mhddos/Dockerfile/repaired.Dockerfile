FROM python:3.8.12-buster

WORKDIR /app
COPY ./ ./
COPY files files

RUN pip3 install --no-cache-dir -r requirements.txt

ENTRYPOINT ["python3", "/app/start.py"]
