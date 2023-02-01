FROM debian
RUN apt-get install -y --no-install-recommends python=2.7 && rm -rf /var/lib/apt/lists/*;