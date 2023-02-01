FROM lamaani/zairflow:latest

COPY . /app
RUN pip3 install --no-cache-dir --user /app