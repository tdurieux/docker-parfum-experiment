FROM resin/raspberrypi-python:3.4
ENV INITSYSTEM on

RUN apt-get update && apt-get upgrade -y
RUN apt-get install --no-install-recommends -y zookeeperd && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libzmq3-dev && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir -vv numpy# this takes an hour to run!
RUN pip install --no-cache-dir kazoo
RUN pip install --no-cache-dir pyzmq
RUN pip install --no-cache-dir requests

COPY . /app
COPY zoo.cfg /etc/zookeeper/conf/zoo.cfg

WORKDIR /app

CMD ["./init.sh"]
