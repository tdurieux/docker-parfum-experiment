FROM docker.io/vhiveease/aws-python:latest
RUN pip install --no-cache-dir chameleon six futures

COPY server.py   ./
CMD ["server.handler"]
