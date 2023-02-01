FROM ubuntu:20.04

RUN apt update && apt install --no-install-recommends -y python3 python3-pip && rm -rf /var/lib/apt/lists/*;
COPY requirements.txt /tmp
RUN pip install --no-cache-dir -r /tmp/requirements.txt
COPY app.py /srv
COPY emojis.txt /srv

WORKDIR /srv
CMD ["python3", "app.py"]
