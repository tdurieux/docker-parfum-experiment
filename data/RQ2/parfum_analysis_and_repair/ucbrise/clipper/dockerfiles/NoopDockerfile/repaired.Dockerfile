ARG REGISTRY
ARG CODE_VERSION
FROM ${REGISTRY}/py-rpc:${CODE_VERSION}

LABEL maintainer="Dan Crankshaw <dscrankshaw@gmail.com>"

MAINTAINER Dan Crankshaw <dscrankshaw@gmail.com>

COPY containers/python/noop_container.py /container/

CMD ["python", "/container/noop_container.py"]

# vim: set filetype=dockerfile: