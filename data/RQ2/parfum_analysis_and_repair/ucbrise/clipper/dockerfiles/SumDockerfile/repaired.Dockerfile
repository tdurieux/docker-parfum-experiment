ARG REGISTRY
ARG CODE_VERSION
FROM ${REGISTRY}/py-rpc:${CODE_VERSION}

LABEL maintainer="Dan Crankshaw <dscrankshaw@gmail.com>"

COPY containers/python/sum_container.py /container/

CMD ["python", "/container/sum_container.py"]

# vim: set filetype=dockerfile: