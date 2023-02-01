FROM python:2.7.13
ADD transaction-generator.py .
RUN pip install --no-cache-dir requests
CMD python transaction-generator.py
