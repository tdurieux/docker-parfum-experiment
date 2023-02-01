FROM busybox
RUN apt-get install --no-install-recommends -y python=2.7 && rm -rf /var/lib/apt/lists/*;