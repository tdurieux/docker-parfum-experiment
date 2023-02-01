FROM python:3.9-slim-buster
# Install python packages
COPY requirements.txt /tmp
RUN pip install --no-cache-dir -r /tmp/requirements.txt
