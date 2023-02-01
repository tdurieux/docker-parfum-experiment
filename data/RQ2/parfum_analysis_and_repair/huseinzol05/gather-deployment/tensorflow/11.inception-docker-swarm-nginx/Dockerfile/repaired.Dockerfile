FROM python:3.6.7-jessie AS base

RUN pip install --no-cache-dir tensorflow Flask numpy Pillow

WORKDIR /app

COPY . /app

CMD ["python3", "app.py"]
