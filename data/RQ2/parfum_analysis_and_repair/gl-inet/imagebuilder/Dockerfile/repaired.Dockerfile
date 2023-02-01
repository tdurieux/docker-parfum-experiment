FROM debian:stretch-slim

RUN apt update && apt install --no-install-recommends -y \
    device-tree-compiler \
    git \
    make \
    python \
    wget && rm -rf /var/lib/apt/lists/*;

RUN if ![ -x python ]; then ln -s /usr/bin/python2.7 /usr/bin/python ;fi

ENV SOURCE_DIR="/src"
WORKDIR ${SOURCE_DIR}

ENTRYPOINT ["python", "gl_image"]
