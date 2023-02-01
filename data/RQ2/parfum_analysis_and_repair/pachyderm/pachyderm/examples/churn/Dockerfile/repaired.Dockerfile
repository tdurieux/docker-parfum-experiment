FROM python:3
RUN pip3 install --no-cache-dir pandas sklearn
COPY churn.py /
