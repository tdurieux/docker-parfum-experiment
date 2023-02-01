FROM launcher.gcr.io/google/ubuntu16_04

RUN apt-get -q update && \
    apt-get install --no-install-recommends -qqy rsync ssh && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT [ "rsync" ]
