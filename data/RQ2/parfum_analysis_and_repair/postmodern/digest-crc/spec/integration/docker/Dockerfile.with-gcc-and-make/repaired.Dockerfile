FROM test-digest-crc-with-gcc

RUN apt-get install --no-install-recommends -y -qq make && rm -rf /var/lib/apt/lists/*;
