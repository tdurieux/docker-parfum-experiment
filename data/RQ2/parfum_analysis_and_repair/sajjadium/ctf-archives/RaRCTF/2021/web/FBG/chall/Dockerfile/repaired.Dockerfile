FROM python:3.8-slim
RUN pip install --no-cache-dir requests flask
COPY . /app
WORKDIR /app
CMD ["python3", "server.py"]
