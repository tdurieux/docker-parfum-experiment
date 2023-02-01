FROM ubuntu:17.04

RUN apt-get update --fix-missing -y && apt-get -y --no-install-recommends install software-properties-common git python3-pip && rm -rf /var/lib/apt/lists/*;

RUN mkdir /halocoin
WORKDIR /halocoin

ADD requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

ADD . /halocoin
RUN pip3 install --no-cache-dir .

VOLUME /data
EXPOSE 7001
EXPOSE 7002

ENTRYPOINT ["/usr/local/bin/coinamid"]
CMD ["start", "--dir", "/data"]