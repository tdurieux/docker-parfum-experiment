FROM python:3.9-slim

WORKDIR /opt/tests
COPY requirements.txt .
RUN apt-get update && apt-get install -y --no-install-recommends -qq \
    gcc \
    libpq-dev \
    git && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir -r requirements.txt
COPY clients ./clients
COPY main.py .
