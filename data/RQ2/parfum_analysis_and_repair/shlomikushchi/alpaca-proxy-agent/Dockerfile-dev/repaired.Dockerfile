FROM python:3.8-slim

WORKDIR /opt/project

COPY requirements.txt /requirements.txt
RUN pip install --no-cache-dir -r /requirements.txt

# Set some environment variables.
# PYTHONUNBUFFERED keeps Python from buffering our standard output stream,
# which means that logs can be delivered to the user quickly.
# PYTHONDONTWRITEBYTECODE keeps Python from writing the .pyc files which are
# unnecessary in this case. We also update

ENV PYTHONUNBUFFERED=TRUE
ENV PYTHONDONTWRITEBYTECODE=TRUE



