FROM ubuntu:20.04

RUN apt-get update && apt-get install --no-install-recommends -qy python3-flask && \
    apt-get clean && rm -rf /var/lib/apt/lists/ && rm -rf /var/lib/apt/lists/*;

ADD app.py \
    /

CMD ["/app.py"]
