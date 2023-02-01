FROM debian:latest
# LABEL maintainer "Avi Kumar @avikumar15"

# Set a working directory
WORKDIR /app

# Copy requirements
COPY requirements.txt requirements.txt
COPY credentials.json credentials.json

RUN apt-get update && apt-get install --no-install-recommends -y \
    software-properties-common \
    python3-setuptools \
    python3-pip \
    nano && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir -r requirements.txt

RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir quick-mail
