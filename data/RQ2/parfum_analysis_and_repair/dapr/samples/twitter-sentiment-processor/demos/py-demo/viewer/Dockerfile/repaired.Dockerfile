FROM python:3.7-slim-buster

WORKDIR /app
COPY . .

RUN pip install --no-cache-dir -r requirements.txt

ENTRYPOINT ["python"]
CMD ["viewer-server.py"]