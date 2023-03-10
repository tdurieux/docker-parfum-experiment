ARG CODE_VERSION
ARG RPC_VERSION
FROM clipper/${RPC_VERSION}-rpc:${CODE_VERSION}

LABEL maintainer="Dan Crankshaw <dscrankshaw@gmail.com>"

RUN pip install --no-cache-dir torch torchvision

COPY containers/python/pytorch_container.py containers/python/container_entry.sh /container/

CMD ["/container/container_entry.sh", "pytorch-container", "/container/pytorch_container.py"]

# vim: set filetype=dockerfile:
