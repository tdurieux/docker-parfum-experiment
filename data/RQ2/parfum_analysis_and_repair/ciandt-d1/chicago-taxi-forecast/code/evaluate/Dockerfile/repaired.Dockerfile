# FROM tensorflow/tensorflow:1.14.0-py3
FROM tensorflow/tensorflow:1.13.1-py3

# General dependencies
RUN apt-get update && apt-get install -y

WORKDIR /app

COPY requirements.txt /assets/requirements.txt
RUN pip install --no-cache-dir -r /assets/requirements.txt

COPY src /app

# COPY service_account.json /assets/service_account.json
# ENV GOOGLE_APPLICATION_CREDENTIALS=/assets/service_account.json
