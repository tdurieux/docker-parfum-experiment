FROM ubuntu:latest
RUN apt-get update -y && apt-get install --no-install-recommends -y python3-pip python3-dev build-essential && rm -rf /var/lib/apt/lists/*;
COPY . /app
WORKDIR /app
RUN pip3 install --no-cache-dir -r requirements.txt
ENTRYPOINT ["python3"]
CMD ["server.py"]
