FROM golang:1.17.3-bullseye

RUN apt update && apt install --no-install-recommends -y python3 python3-pip && rm -rf /var/lib/apt/lists/*;

RUN mkdir /workerfiles

WORKDIR /workerdev

COPY ./go.mod /workerdev/go.mod

RUN go mod download

RUN apt-get install --no-install-recommends -y sysstat && rm -rf /var/lib/apt/lists/*;

COPY examples/python-worker /workerfiles/python-worker

RUN pip3 install --no-cache-dir -r /workerfiles/python-worker/requirements.txt

CMD ["go","run","worker.go"]