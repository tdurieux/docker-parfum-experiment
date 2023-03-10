ARG CODE_VERSION
ARG RPC_VERSION
FROM clipper/${RPC_VERSION}-rpc:${CODE_VERSION}

LABEL maintainer="Dan Crankshaw <dscrankshaw@gmail.com>"

COPY containers/python/python_closure_container.py \
       containers/python/container_entry.sh /container/

ENTRYPOINT ["/container/container_entry.sh", "py-closure-container", "/container/python_closure_container.py"]

# vim: set filetype=dockerfile: