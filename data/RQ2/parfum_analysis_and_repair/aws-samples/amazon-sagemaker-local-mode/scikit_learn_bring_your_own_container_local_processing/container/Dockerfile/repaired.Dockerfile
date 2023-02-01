FROM python:3.7-slim-buster

# Install scikit-learn and pandas
RUN pip3 install --no-cache-dir pandas==0.25.3 scikit-learn==0.21.3

ENTRYPOINT ["python3"]