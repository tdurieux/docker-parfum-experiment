FROM replicator

RUN pip install --no-cache-dir pytest
ENTRYPOINT ["py.test"]
