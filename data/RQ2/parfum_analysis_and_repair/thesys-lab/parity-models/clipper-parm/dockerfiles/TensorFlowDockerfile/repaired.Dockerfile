ARG CODE_VERSION
ARG RPC_VERSION
FROM clipper/${RPC_VERSION}-rpc:${CODE_VERSION}

LABEL maintainer="Dan Crankshaw <dscrankshaw@gmail.com>"

RUN pip install --no-cache-dir tensorflow==1.6.*

COPY containers/python/tf_container.py containers/python/container_entry.sh /container/

CMD ["/container/container_entry.sh", "tensorflow-container", "/container/tf_container.py"]

# vim: set filetype=dockerfile:
