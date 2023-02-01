FROM test-digest-crc-base

RUN apt-get install --no-install-recommends -y -qq gcc && rm -rf /var/lib/apt/lists/*;
