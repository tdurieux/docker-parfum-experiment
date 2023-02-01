FROM ubuntu:20.04

COPY . /app

WORKDIR /app

RUN apt-get update && apt-get install --no-install-recommends -y socat && rm -rf /var/lib/apt/lists/*;
RUN useradd -UM chall

CMD /app/start.sh
