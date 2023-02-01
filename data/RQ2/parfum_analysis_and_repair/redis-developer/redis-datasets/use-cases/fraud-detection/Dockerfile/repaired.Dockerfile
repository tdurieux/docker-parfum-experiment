FROM ubuntu:18.04

RUN apt-get update -y && \
    apt-get install --no-install-recommends -y python3.7 python3-pip build-essential git && rm -rf /var/lib/apt/lists/*;

WORKDIR /app
ADD ./app /app
COPY requirements.txt /app
RUN pip3 install --no-cache-dir -r /app/requirements.txt

CMD ["python3", "/app/app.py"]