# Test docker file (used by CI)
FROM python:3.8-slim
RUN apt-get update && apt-get install --no-install-recommends -y bzip2 curl gcc && rm -rf /var/lib/apt/lists/*;
RUN curl -f -LO https://dl.google.com/go/go1.14.4.linux-amd64.tar.gz
RUN tar xzf go1.14.4.linux-amd64.tar.gz && rm go1.14.4.linux-amd64.tar.gz
RUN ln -s /go/bin/go /usr/local/bin
RUN python -m pip install --upgrade pip
COPY ./testdata/logs /tmp/logs
WORKDIR /code
COPY . .
RUN go mod init github.com/ardanlabs/python-go/pyext
RUN go build -buildmode=c-shared -o _checksig.so
RUN python py_session.py
