FROM tiangolo/uvicorn-gunicorn-fastapi:python3.8-slim
COPY . /app
RUN pip install --no-cache-dir -r requirements.txt