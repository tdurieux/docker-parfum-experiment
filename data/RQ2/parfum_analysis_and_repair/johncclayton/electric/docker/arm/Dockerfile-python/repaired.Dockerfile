FROM johncclayton/electric-pi-base:latest

LABEL maintainer="Neil Clayton, John Clayton" \
    version="1.0"

VOLUME /www

COPY ./src/server/ /www

WORKDIR /www

ENV MAKEFLAGS="-j 4"

RUN pip install --no-cache-dir -r requirements-all.txt \
    && rm -rf /www/scripts /www/MANIFEST /www/requirements*.txt /www/old-setup /www/DEVELOPMENT.md /www/pypirc_template /www/setup.py \
    && chmod +x /www/run_gunicorn.sh \
    && chmod +x /www/run_zmq_worker.sh \
    && apk del gcc g++ python-dev libusb-dev eudev-dev linux-headers gcc musl-dev cython cython-dev --purge