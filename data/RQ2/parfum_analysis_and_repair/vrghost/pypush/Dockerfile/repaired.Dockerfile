FROM python:2.7

ENV PORT=5000
ENV DRIVER="bluegiga"
ENV DEVICE="/dev/ttyACM*"
ENV APPLICATION_ROOT="/microbots"
ENV HOST_MOUNDED_DIR="/usr/src/PyPush/host_mounted"

RUN apt-get update && apt-get install --no-install-recommends -y libglib2.0-dev libusb-dev libdbus-1-dev libudev-dev libical-dev libreadline-dev libboost-all-dev libboost-python-dev libbluetooth-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get clean

RUN mkdir -p /usr/src && rm -rf /usr/src
WORKDIR /usr/src
COPY ./requirements/ /usr/src/requirements

RUN pip install --no-cache-dir -r requirements/prod.txt
RUN pip install --no-cache-dir -r requirements/bluez.txt

WORKDIR /usr/src/PyPush
COPY ./ /usr/src/PyPush
RUN rm -rf .git

RUN mkdir "${HOST_MOUNDED_DIR}"
VOLUME [ "${HOST_MOUNDED_DIR}" ]

EXPOSE $PORT
CMD [ "sh", "-c", "./bin/docker/serve.sh" ]