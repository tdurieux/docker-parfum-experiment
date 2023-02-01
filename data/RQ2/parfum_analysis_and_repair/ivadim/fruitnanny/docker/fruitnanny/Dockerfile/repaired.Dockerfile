FROM balenalib/raspberry-pi-node:12.11-buster

RUN buildDeps="build-essential python-dev python3-dev python-setuptools python3-setuptools" \
    && echo 'APT::Install-Recommends "false";' >/etc/apt/apt.conf.d/00recommends \
    && echo 'APT::Install-Suggests "false";' >>/etc/apt/apt.conf.d/00recommends \
    && apt-get update \
    && apt-get install --no-install-recommends -y python-pip python3-pip dos2unix \
    && apt-get install --no-install-recommends -y $buildDeps \
    && pip install --no-cache-dir wheel && pip install --no-cache-dir --install-option="--force-pi2" Adafruit-DHT \
    && pip3 install --no-cache-dir wheel && pip3 install --no-cache-dir --install-option="--force-pi2" Adafruit-DHT \
    && apt-get --purge remove -y $buildDeps && apt-get --purge -y autoremove \
    && apt-get clean \
    && rm -rf /tmp/* \
    && rm -rf /var/lib/apt/lists/*

ADD . /opt/fruitnanny
WORKDIR /opt/fruitnanny

RUN dos2unix /opt/fruitnanny/bin/*

RUN npm install && npm cache clean --force;
CMD ["node", "server/app.js"]
EXPOSE 7000
