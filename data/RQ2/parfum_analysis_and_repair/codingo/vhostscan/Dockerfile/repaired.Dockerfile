FROM ubuntu:latest

RUN mkdir /app

ADD . /app

RUN apt-get update; apt-get install --no-install-recommends -y python3 python3-pip && rm -rf /var/lib/apt/lists/*;

RUN cd /app && pip3 install --no-cache-dir -r test-requirements.txt && python3 setup.py install

ENTRYPOINT ["VHostScan"]
