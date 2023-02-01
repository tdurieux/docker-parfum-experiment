FROM python:3.7.2-slim

COPY . /app
WORKDIR /app

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir flask


ENTRYPOINT ["python", "app.py"]

