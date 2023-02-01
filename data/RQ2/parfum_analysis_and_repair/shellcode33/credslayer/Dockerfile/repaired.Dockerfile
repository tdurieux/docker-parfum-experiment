# This docker file is only used as a test environment
# it will run unit tests with the expected system configuration

FROM ubuntu:18.04

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y tshark python3-pip && rm -rf /var/lib/apt/lists/*;

COPY . /app
WORKDIR /app

RUN pip3 install --no-cache-dir -r requirements.txt
CMD python3 -m unittest tests/tests.py