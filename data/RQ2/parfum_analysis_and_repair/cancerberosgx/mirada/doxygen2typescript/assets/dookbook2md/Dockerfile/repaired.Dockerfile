FROM ALPINE

RUN export TERM=xterm \
 && apt-get --assume-yes --list-cleanup update \
 && apt-get --yes --no-install-recommends install docbook docbook-utils openjade make && rm -rf /var/lib/apt/lists/*;