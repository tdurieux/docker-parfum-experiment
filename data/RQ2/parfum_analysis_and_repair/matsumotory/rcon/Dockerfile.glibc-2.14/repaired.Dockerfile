FROM hone/mruby-cli
RUN apt-get -y --no-install-recommends install libpam0g-dev flex && rm -rf /var/lib/apt/lists/*;
