FROM iotedgedev-windows-base
ARG IOTEDGEDEV_VERSION
COPY iotedgedev-$IOTEDGEDEV_VERSION-py3-none-any.whl dist/iotedgedev-latest-py3-none-any.whl
RUN pip install --no-cache-dir dist/iotedgedev-latest-py3-none-any.whl