FROM ubuntu:latest
MAINTAINER NerdBear "python@istruly.sexy"
RUN apt-get update -y && apt-get install --no-install-recommends -y python-pip python-dev build-essential && rm -rf /var/lib/apt/lists/*;
COPY . /app
WORKDIR /app
RUN pip install --no-cache-dir -r requirements.txt
ENTRYPOINT ["python", "Server/run_server.py"]