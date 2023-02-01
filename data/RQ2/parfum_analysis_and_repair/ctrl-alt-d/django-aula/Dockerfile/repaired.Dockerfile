FROM python:3.8-slim

WORKDIR /app
COPY . /app
RUN apt update && apt install --no-install-recommends --no-install-suggests -y git wait-for-it && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir -r requirements.txt
