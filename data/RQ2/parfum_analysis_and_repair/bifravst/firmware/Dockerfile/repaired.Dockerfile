FROM coderbyheart/fw-nrfconnect-nrf-docker:latest
RUN rm -rf /workdir/ncs
COPY . /workdir/ncs/firmware
RUN \

    cd /workdir/ncs/firmware; west init -l && \
    cd /workdir/ncs; west update && \
    pip3 install --no-cache-dir -r zephyr/scripts/requirements.txt && \
    pip3 install --no-cache-dir -r nrf/scripts/requirements.txt && \
    pip3 install --no-cache-dir -r bootloader/mcuboot/scripts/requirements.txt && \
    rm -rf /workdir/ncs/firmware
