FROM python:3.10-slim

RUN apt-get update && apt -y --no-install-recommends install build-essential && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir --upgrade pip

RUN pip3 install --no-cache-dir -U pylint
RUN pip3 install --no-cache-dir pandas sklearn
RUN pip3 install --no-cache-dir pytest matplotlib

RUN mkdir /src
WORKDIR /src
ENTRYPOINT ["pylint"]
