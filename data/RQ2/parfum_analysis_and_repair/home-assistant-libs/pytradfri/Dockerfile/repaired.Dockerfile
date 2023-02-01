FROM python:3.10-stretch

COPY . /usr/src/app/

RUN mkdir -p /usr/src/build && \
    cd /usr/src/build && \
    pip3 install --no-cache-dir --upgrade pip setuptools wheel cython && \
    pip3 install --no-cache-dir -r /usr/src/app/requirements.txt && \
    chmod +x /usr/src/app/script/install-coap-client.sh && \
    /usr/src/app/script/install-coap-client.sh && \
    pip3 install --no-cache-dir -e /usr/src/app/ && rm -rf /usr/src/build

WORKDIR /usr/src/app
