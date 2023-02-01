FROM debian:9.2

RUN apt-get update && apt-get install --no-install-recommends -y curl python3 python3-pip && rm -rf /var/lib/apt/lists/*;

ADD images /home/images
COPY normal.py /home/normal.py

ENTRYPOINT ["python3", "-u", "/home/normal.py"]
CMD []