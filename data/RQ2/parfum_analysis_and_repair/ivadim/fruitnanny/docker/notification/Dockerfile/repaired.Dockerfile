FROM ivadim/fruitnanny-app

RUN apt-get update \
    && apt-get install --no-install-recommends -y libgpiod2 \
    && pip3 install --no-cache-dir adafruit-circuitpython-lis3dh \
    && pip3 install --no-cache-dir adafruit-circuitpython-dht \
    && pip3 install --no-cache-dir pushbullet.py \
    && pip3 install --no-cache-dir configparser \
    && pip3 install --no-cache-dir adafruit-blinka \
    && apt-get --purge remove -y $buildDeps && apt-get --purge -y autoremove \
    && apt-get clean \
    && rm -rf /tmp/* \
    && rm -rf /var/lib/apt/lists/*