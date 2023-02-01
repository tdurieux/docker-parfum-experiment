FROM qgis/qgis:final-3_24_2

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    python3-pip \
    xvfb \
    iputils-ping \
    && apt-get clean

WORKDIR /usr/src/app

# crashes to STDERR
ENV LD_PRELOAD="/lib/x86_64-linux-gnu/libSegFault.so"
ENV SEGFAULT_SIGNALS="abrt segv"
ENV LIBC_FATAL_STDERR_=1

# other env
ENV LANG=C.UTF-8
ENV PYTHONPATH="/usr/src/app/lib:${PYTHONPATH}"

COPY ./requirements.txt /tmp/
RUN pip3 install -r /tmp/requirements.txt

COPY entrypoint.py .
COPY ./apply_deltas.py ./lib/qfieldcloud/qgis/
COPY ./process_projectfile.py ./lib/qfieldcloud/qgis/
COPY ./utils.py ./lib/qfieldcloud/qgis/
COPY ./schemas/deltafile_01.json ./schemas/
COPY ./libqfieldsync ./lib/libqfieldsync

ENTRYPOINT ["/bin/sh", "-c", "/usr/bin/xvfb-run -a \"$@\"", ""]
