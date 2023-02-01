FROM operator-courier-integration-base:latest

WORKDIR /operator-courier
COPY . .
RUN pip3 install --no-cache-dir .
