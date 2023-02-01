FROM nginx:alpine

RUN apk add --no-cache -U python3 gcc musl-dev linux-headers python3-dev libffi-dev make

RUN apk add --no-cache openssl-dev

RUN apk add --no-cache zeromq-dev && \
    pip3 install --no-cache-dir docker pyzmq cryptography sphinx \
                 Pallets-Sphinx-Themes sphinx-autobuild

ADD . /madt

CMD if [ -z "$LIVEHTML" ]; then \
        sphinx-build -b html /madt/docs /usr/share/nginx/html && \
        nginx -g "daemon off;"; \
    else cd /madt/docs && make livehtml; fi