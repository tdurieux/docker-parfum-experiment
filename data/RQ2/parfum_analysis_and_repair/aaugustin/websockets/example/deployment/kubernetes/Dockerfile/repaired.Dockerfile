FROM python:3.9-alpine

RUN pip install --no-cache-dir websockets

COPY app.py .

CMD ["python", "app.py"]
