FROM ubuntu:14.04
RUN apt-get update && apt-get install --no-install-recommends -y default-jdk git build-essential tcl curl && rm -rf /var/lib/apt/lists/*;
RUN cd /root/ && curl -f -O http://download.redis.io/redis-stable.tar.gz
RUN cd /root/ && tar xzvf redis-stable.tar.gz && rm redis-stable.tar.gz
RUN cd /root/redis-stable && make
RUN cd /root/ && git clone https://github.com/andreibaranouski/CbTest.git
RUN cd /root/CbTest && chmod 777 -R startLoader.sh