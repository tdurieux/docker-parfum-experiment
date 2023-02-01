FROM ubuntu:16.04
RUN apt-get update -y && apt-get install --no-install-recommends -y python3 python3-pip python-pycurl libcurl4-openssl-dev openssl libssl-dev postgresql && rm -rf /var/lib/apt/lists/*;

ADD . /api-tests

RUN pip3 install --no-cache-dir -r /api-tests/requirements.txt

CMD ["/scripts/prep-db-and-run-tests.sh"]