FROM ubuntu:latest
RUN apt update && apt install --no-install-recommends -y socat && mkdir /harmony && rm -rf /var/lib/apt/lists/*;
WORKDIR /harmony
COPY run.sh ./run.sh
COPY harmony ./harmony
COPY channels ./channels
EXPOSE 5000
ENTRYPOINT ["socat", "tcp-l:5000,reuseaddr,fork", "EXEC:/harmony/run.sh,stderr"]

