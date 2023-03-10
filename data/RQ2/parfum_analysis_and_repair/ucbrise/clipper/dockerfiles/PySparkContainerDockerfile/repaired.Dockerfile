ARG REGISTRY
ARG CODE_VERSION
ARG RPC_VERSION
FROM ${REGISTRY}/${RPC_VERSION}-rpc:${CODE_VERSION}

LABEL maintainer="Dan Crankshaw <dscrankshaw@gmail.com>"

RUN mkdir -p /usr/share/man/man1 && \
    apt-get update -qq -y && \
    apt-get install --no-install-recommends openjdk-8-jre openjdk-8-jdk-headless -y && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y -qq wget && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir -q pyspark==2.3.*

# Test PySpark and JDK installation
RUN wget https://raw.githubusercontent.com/apache/spark/master/examples/src/main/python/pi.py && mv pi.py /tmp/pi.py && python /tmp/pi.py

COPY containers/python/pyspark_container.py containers/python/container_entry.sh /container/

CMD ["/container/container_entry.sh", "pyspark-container", "/container/pyspark_container.py"]

# vim: set filetype=dockerfile:
