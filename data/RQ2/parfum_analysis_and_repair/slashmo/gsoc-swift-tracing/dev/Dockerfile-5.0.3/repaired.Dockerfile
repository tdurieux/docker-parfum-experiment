FROM swift:5.0.3

RUN apt-get -qq update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y libz-dev && rm -rf /var/lib/apt/lists/*;
