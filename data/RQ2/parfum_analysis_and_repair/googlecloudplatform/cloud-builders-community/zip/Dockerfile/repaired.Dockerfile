FROM launcher.gcr.io/google/ubuntu16_04

RUN apt-get update && \
    apt-get -y --no-install-recommends install zip && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["zip"]