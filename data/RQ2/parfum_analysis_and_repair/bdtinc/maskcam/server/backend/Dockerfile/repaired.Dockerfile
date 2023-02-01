FROM tiangolo/uvicorn-gunicorn-fastapi:python3.7

COPY ./app /app
COPY requirements.txt /app/requirements.txt

ENV PYTHONPATH=/app
WORKDIR /app

RUN python -m pip install --upgrade pip && pip install --no-cache-dir -r requirements.txt
