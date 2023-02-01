FROM python:3.6-slim
LABEL Noah Yoshida "nyoshida@nd.edu"
RUN apt-get update -y && apt-get install --no-install-recommends -y gcc libc-dev && rm -rf /var/lib/apt/lists/*;

COPY . /app
ENV HOME=/app
WORKDIR /app

RUN pip3 install --no-cache-dir -r requirements.txt
EXPOSE 80

ENTRYPOINT ["python3", "server.py"]
