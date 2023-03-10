FROM debian:11-slim
WORKDIR /app
RUN apt-get update && \
  apt-get install --no-install-recommends -y python3 python3-pip && \
  rm -rf /var/lib/apt/lists/*
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt
COPY . .
CMD ["python3", "app.py"]
EXPOSE 80