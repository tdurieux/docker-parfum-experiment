FROM python:2.7-slim

RUN apt-get update
RUN apt-get install --no-install-recommends -y wget unzip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libzookeeper-mt-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y gcc && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir zkpython

RUN wget https://github.com/phunt/zk-smoketest/archive/master.zip -O zk-smoketest.zip; \
    unzip zk-smoketest.zip; \
    rm zk-smoketest.zip

EXPOSE 2181

ENTRYPOINT ["zk-smoketest-master/zk-latencies.py"]
