FROM python:3.8-alpine

RUN pip install --no-cache-dir requests
ADD main.py .

ENTRYPOINT ["python", "main.py"]
