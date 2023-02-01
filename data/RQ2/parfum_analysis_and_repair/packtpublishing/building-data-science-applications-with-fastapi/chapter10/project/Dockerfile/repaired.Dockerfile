FROM tiangolo/uvicorn-gunicorn-fastapi:python3.7

ENV APP_MODULE app.app:app

COPY requirements.txt /app

RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r /app/requirements.txt

COPY ./ /app
