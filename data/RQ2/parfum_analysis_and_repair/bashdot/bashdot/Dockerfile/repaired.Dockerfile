FROM ubuntu

RUN apt-get update --fix-missing && apt-get install --no-install-recommends -y bats vim && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /root/another_test

COPY testdata/ /root/
COPY testdata/ /root/another_test/
COPY bashdot /usr/bin
COPY test.bats /root

RUN chmod 755 /usr/bin/bashdot
RUN rm -f /root/.bashrc

ENTRYPOINT ["bats", "/root/test.bats"]
