FROM ubuntu:18.04
RUN apt-get update && apt-get upgrade -y
RUN apt-get install --no-install-recommends -y socat python3 && rm -rf /var/lib/apt/lists/*;


COPY . /

CMD ["socat", "-T60", "TCP-LISTEN:8000,reuseaddr,fork", "EXEC:'/usr/bin/python3 /main.py'"]
