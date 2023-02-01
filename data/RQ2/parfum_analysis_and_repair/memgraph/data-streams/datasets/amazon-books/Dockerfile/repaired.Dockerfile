FROM python:3.8

# Install packages
COPY /datasets/amazon-books/requirements.txt ./
RUN pip3 install --no-cache-dir -r requirements.txt

COPY /datasets/amazon-books/ /app/
COPY /stream /app/stream/
WORKDIR /app
