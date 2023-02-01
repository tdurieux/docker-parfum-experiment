FROM docksal/cli:2.12-php7.4

RUN apt-get install -y --no-install-recommends rename && rm -rf /var/lib/apt/lists/*;
