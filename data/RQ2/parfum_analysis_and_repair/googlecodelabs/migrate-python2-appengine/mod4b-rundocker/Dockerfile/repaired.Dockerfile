FROM python:3-slim
WORKDIR /app
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
ENTRYPOINT exec gunicorn -b :$PORT -w 2 main:app
