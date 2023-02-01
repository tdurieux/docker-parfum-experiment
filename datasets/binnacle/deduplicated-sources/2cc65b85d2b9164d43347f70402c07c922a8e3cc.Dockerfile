FROM esphome/esphome-base-amd64:1.8.3

RUN \
    apt-get update \
    && apt-get install -y --no-install-recommends \
        clang-format-7 \
        clang-tidy-7 \
        patch \
    && rm -rf \
        /tmp/* \
        /var/{cache,log}/* \
        /var/lib/apt/lists/*

COPY requirements_test.txt /requirements_test.txt
RUN pip2 install --no-cache-dir wheel && pip2 install --no-cache-dir -r /requirements_test.txt

VOLUME ["/esphome"]
WORKDIR /esphome
