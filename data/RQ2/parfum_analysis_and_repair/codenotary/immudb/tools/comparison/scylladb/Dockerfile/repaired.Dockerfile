FROM scylladb/scylla
RUN curl -f https://bootstrap.pypa.io/get-pip.py -o get-pip.py
RUN python get-pip.py
RUN pip install --no-cache-dir cassandra-driver
ADD . .
ENTRYPOINT [ "/run.sh" ]
