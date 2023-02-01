FROM ubuntu:latest
RUN apt-get -y update && apt-get install --no-install-recommends -y xinetd && \
    useradd -m qdb && \
    chmod 700 -R /home/qdb && rm -rf /var/lib/apt/lists/*;

COPY ./qdb /home/qdb/
COPY ./xinetd.conf /etc/xinetd.d/qdb
COPY ./quotes.txt /quotes.txt


CMD ["/usr/sbin/xinetd", "-dontfork"]
