FROM python:3.5
ADD timeout_test.py /
RUN pip install --no-cache-dir microservices