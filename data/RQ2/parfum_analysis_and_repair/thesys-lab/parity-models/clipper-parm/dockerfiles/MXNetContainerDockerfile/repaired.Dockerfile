ARG CODE_VERSION
ARG RPC_VERSION
FROM clipper/${RPC_VERSION}-rpc:${CODE_VERSION}

LABEL maintainer="Dan Crankshaw <dscrankshaw@gmail.com>"

RUN pip install --no-cache-dir mxnet==1.1.*

COPY containers/python/mxnet_container.py containers/python/container_entry.sh /container/

CMD ["/container/container_entry.sh", "mxnet-container", "/container/mxnet_container.py"]

# vim: set filetype=dockerfile:
