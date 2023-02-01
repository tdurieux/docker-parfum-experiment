FROM ubuntu:16.04
RUN apt-get update -y && apt-get install --no-install-recommends -y build-essential gcc libc-bin libaio1 git && rm -rf /var/lib/apt/lists/*;

WORKDIR /

COPY dbtransfer.tar.gz .

ENV VERTICAINI=/etc/vertica.ini
ENV PKG_CONFIG_PATH=/
ENV LD_LIBRARY_PATH=/usr/local/lib:/usr/lib/oracle/12.2/client64/lib
RUN tar xvzf /dbtransfer.tar.gz && rm dbtransfer.tar.gz

CMD ["/dbtransfer"]
