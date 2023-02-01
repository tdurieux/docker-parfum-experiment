FROM python:3.8

# Install packages
COPY /datasets/github/requirements.txt ./
RUN pip3 install --no-cache-dir -r requirements.txt

COPY /datasets/github/ /app/
COPY /stream /app/stream/
WORKDIR /app
