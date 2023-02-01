# set base image
# Base image is a lightweight version of Python
FROM python:3.9-slim-buster

# Install required software
RUN apt update && apt install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED=1

# set the working directory in the container
WORKDIR /root/bms-bacnet

# copy the dependencies file to the working directory
COPY requirements.txt .

# install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# copy the content of the local src directory to the working directory
COPY ./ .

ENTRYPOINT ["python",  "app.py"]