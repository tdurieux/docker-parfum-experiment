From python:3.6-slim

RUN pip install --no-cache-dir pymilvus==2.0.0

ENTRYPOINT ["python"]
