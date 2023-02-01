FROM docker.io/vhiveease/aws-python:latest
RUN pip install --no-cache-dir futures

COPY server.py   ./
CMD ["server.handler"]
