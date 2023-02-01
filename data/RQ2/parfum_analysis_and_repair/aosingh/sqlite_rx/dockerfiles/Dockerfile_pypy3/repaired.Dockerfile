FROM pypy:3-slim

RUN apt-get update
RUN apt-get -y --no-install-recommends install g++ && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libzmq3-dev && rm -rf /var/lib/apt/lists/*;

COPY . /sqlite_rx
WORKDIR /sqlite_rx

RUN pypy3 -m pip install -r requirements.txt
RUN pypy3 setup.py install