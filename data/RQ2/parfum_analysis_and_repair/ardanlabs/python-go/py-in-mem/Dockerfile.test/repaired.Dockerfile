FROM python:3.8-slim
RUN apt-get update && apt-get install --no-install-recommends -y curl gcc make pkg-config && rm -rf /var/lib/apt/lists/*;
RUN curl -f -LO https://golang.org/dl/go1.14.7.linux-amd64.tar.gz
RUN tar xz -C /opt -f go1.14.7.linux-amd64.tar.gz && rm go1.14.7.linux-amd64.tar.gz
ENV PATH="/opt/go/bin:${PATH}"
RUN python -m pip install --upgrade pip
RUN python -m pip install numpy~=1.19
WORKDIR /py-in-mem
COPY . .
RUN go mod init github.com/ardanlabs/python-go/pyinmem
RUN make test
