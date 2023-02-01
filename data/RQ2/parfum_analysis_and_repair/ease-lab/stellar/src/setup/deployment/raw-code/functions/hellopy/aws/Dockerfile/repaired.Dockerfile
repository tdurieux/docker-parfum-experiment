FROM docker.io/vhiveease/aws-python:latest
RUN pip install --no-cache-dir futures

COPY lambda_function.py   ./
CMD ["lambda_function.lambda_handler"]
