## Alpine-based
ARG BUILD_FROM="homeassistant/amd64-base:latest"

FROM ${BUILD_FROM} AS build-base
ENV LANG C.UTF-8
ENV PIP_FLAGS="--no-cache-dir --extra-index-url https://www.piwheels.org/simple"
ENV CFLAGS="-fcommon"

RUN apk add --no-cache --virtual .build \
        git \
        python3-dev \
        python2-dev \
        py3-virtualenv \
        build-base \
        linux-headers \
        cmake



FROM build-base AS octoprint
ENV PYTHONPATH=/data/python/OctoPrint
ENV PYTHONUSERBASE=/data/python/OctoPrint
ENV PATH=${PATH}:/data/python/OctoPrint/bin

RUN echo "Install OctoPrint" \
    && virtualenv --python=python3 /data/python/OctoPrint \
    && source /data/python/OctoPrint/bin/activate \
    && pip install --no-cache-dir ${PIP_FLAGS} --upgrade pip wheel \
    && pip install --no-cache-dir ${PIP_FLAGS} --upgrade OctoPrint



FROM build-base AS mjpg-streamer
RUN echo "Install mjpg-streamer" \
    && apk add --no-cache \
        libjpeg-turbo-dev \
    && git clone --depth 1 https://github.com/jacksonliam/mjpg-streamer \
    && cd mjpg-streamer/mjpg-streamer-experimental/ \
    && make --silent \
    && make install --silent \
    && mv www/ /www_mjpg



FROM build-base AS klipper
ENV PYTHONPATH=/data/python/Klipper
ENV PYTHONUSERBASE=/data/python/Klipper
ENV PATH=${PATH}:/data/python/Klipper/bin

RUN echo "Install Klipper" \
    && apk add --no-cache \
        libffi-dev \
        freetype-dev \
        libpng-dev \
    && virtualenv --python=python2.7 /data/python/Klipper \
    && source /data/python/Klipper/bin/activate \
    && pip install --no-cache-dir ${PIP_FLAGS} --upgrade pip wheel \
    && git clone --depth 1 https://github.com/Klipper3d/klipper.git /data/klipper \
    && pip install --no-cache-dir ${PIP_FLAGS} -r /data/klipper/scripts/klippy-requirements.txt \
    && pip install --no-cache-dir ${PIP_FLAGS} --upgrade numpy
COPY rootfs/data/klipper/.config /data/klipper/.config
# Need to make two changes to /data/klipper/src/linux/main.c due to sched_setscheduler not being available in Alpine:
# - Add #include<pthread.h>
# - Replace sched_setscheduler(0, SCHED_FIFO, &sp); with pthread_setschedparam(pthread_self(), SCHED_FIFO, &sp);
RUN sed -i 's"// sched_main"// sched_main\n#include <pthread.h>"' /data/klipper/src/linux/main.c
RUN sed -i 's/sched_setscheduler(0/pthread_setschedparam(pthread_self()/' /data/klipper/src/linux/main.c
RUN cd /data/klipper \
    && make clean \
    && make \
    && ./scripts/flash-linux.sh



FROM build-base AS curaengine
ARG CURA_VERSION=15.04.6
RUN echo "Install CuraEngine" \
    && apk add --no-cache libexecinfo-dev \
    && git clone -b ${CURA_VERSION} --depth 1 https://github.com/Ultimaker/CuraEngine \
    && cd CuraEngine \
    && make --silent \
    && mv build/CuraEngine /usr/local/bin/CuraEngine



FROM ${BUILD_FROM} AS final
ENV LANG C.UTF-8
ENV PIP_FLAGS="--no-cache-dir --extra-index-url https://www.piwheels.org/simple"
ENV CFLAGS="-fcommon"
ENV PATH=${PATH}:/data/python/OctoPrint/bin:/data/python/Klipper/bin

RUN echo "Install required packages for running." \
    && apk add --no-cache \
        python2 \
        python3 \
        caddy
RUN echo "Install additional packages" \
    && apk add --no-cache --virtual .extras \
        gphoto2 \
        ffmpeg \
        libjpeg-turbo \
        zlib \
        build-base \
        linux-headers \
        python3-dev \
        vim \
        git \
        avrdude \
        # dfu-programmer \
        # dfu-util \
        stm32flash

# Copy data from previous stages and do some setup.
# ## OctoPrint
COPY --from=octoprint /data/python/OctoPrint /data/python/OctoPrint
COPY rootfs/data/config/octoprint /data/config/octoprint
RUN ln -s /data/config/octoprint $HOME/.octoprint
# ## mjpg-streamer
COPY --from=mjpg-streamer /usr/local/lib/mjpg-streamer /usr/local/lib/mjpg-streamer
COPY --from=mjpg-streamer /usr/local/share/mjpg-streamer /usr/local/share/mjpg-streamer
COPY --from=mjpg-streamer /usr/local/bin/mjpg_streamer /usr/local/bin/mjpg_streamer
COPY --from=mjpg-streamer /www_mjpg /www_mjpg
# ## Klipper
COPY --from=klipper /data/python/Klipper /data/python/Klipper
COPY --from=klipper /data/klipper /data/klipper
COPY --from=klipper /usr/local/bin/klipper_mcu /usr/local/bin/klipper_mcu
# ## CuraEngine
COPY --from=curaengine /usr/local/bin/CuraEngine /usr/local/bin/CuraEngine

COPY rootfs/ /
RUN chmod a+x /scripts/*.sh
WORKDIR /

# Cleanup, move files in /data to archives.
RUN echo "Cleanup and move output" \
    && mkdir -p /data/python/OctoPrint \
    && mkdir -p /data/python/Klipper \
    && mkdir -p /data/klipper \
    && find /data/python/OctoPrint | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf \
    && find /data/python/Klipper | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf \
    && find /usr/lib/python* | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf \
    && rm -rf /root/.cache \
    && cd /data/python && tar -zcf /root/OctoPrint-python.tar.gz OctoPrint \
    && cd /data/config && tar -zcf /root/OctoPrint-config.tar.gz octoprint \
    && cd /data/python && tar -zcf /root/Klipper-python.tar.gz Klipper \
    && cd /data && tar -zcf /root/Klipper-src.tar.gz klipper \
    && rm -rf /data/* && rm /root/OctoPrint-python.tar.gz
