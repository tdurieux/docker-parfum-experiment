FROM python:3.8

COPY        /app /app
ADD         requirements.txt /app
RUN pip install --no-cache-dir -r /app/requirements.txt

ENTRYPOINT  ["python", "/app/main.py"]
