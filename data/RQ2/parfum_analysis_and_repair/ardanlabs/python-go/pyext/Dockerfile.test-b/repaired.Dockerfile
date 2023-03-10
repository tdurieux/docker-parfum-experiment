FROM python:3.8-slim
RUN apt-get update && apt-get install --no-install-recommends -y bzip2 curl gcc && rm -rf /var/lib/apt/lists/*;
RUN curl -f -LO https://dl.google.com/go/go1.14.4.linux-amd64.tar.gz
RUN tar xzf go1.14.4.linux-amd64.tar.gz && rm go1.14.4.linux-amd64.tar.gz
RUN ln -s /go/bin/go /usr/local/bin
RUN python -m pip install --upgrade pip
COPY ./testdata/logs /tmp/logs
WORKDIR /code
COPY . .
COPY example.py /tmp
RUN go mod init github.com/ardanlabs/python-go/pyext
RUN python setup.py sdist
RUN python setup.py bdist_wheel
WORKDIR /tmp
# Check wheel
RUN python -m pip install /code/dist/checksig-0.1.0-cp38-cp38-linux_x86_64.whl
RUN python example.py
# Check sdist
RUN python -m pip uninstall -y checksig
RUN python -m pip install /code/dist/checksig-0.1.0.tar.gz
RUN python example.py
