FROM {{ consul_image }}:{{ consul_tag }}

RUN apk add --no-cache jq bash python python-dev py-pip && \
    pip install --no-cache-dir requests pyyaml
