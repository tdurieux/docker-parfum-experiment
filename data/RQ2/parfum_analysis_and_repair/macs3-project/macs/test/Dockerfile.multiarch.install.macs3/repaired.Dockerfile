ARG BASE_IMAGE=${BASE_IMAGE}
FROM ${BASE_IMAGE}

ENV TEST_USER macs

WORKDIR /build
COPY . .
USER "${TEST_USER}"
ENV PATH "/home/${TEST_USER}/.local/bin:${PATH}"
RUN pip3 install --user . --no-cache-dir