ARG REGISTRY
ARG CODE_VERSION
ARG RPC_VERSION
FROM ${REGISTRY}/${RPC_VERSION}-rpc:${CODE_VERSION}

LABEL maintainer="Dan Crankshaw <dscrankshaw@gmail.com>"

RUN pip install --no-cache-dir -q mxnet==1.4.*

COPY containers/python/mxnet_container.py containers/python/container_entry.sh /container/

CMD ["/container/container_entry.sh", "mxnet-container", "/container/mxnet_container.py"]

# vim: set filetype=dockerfile:
