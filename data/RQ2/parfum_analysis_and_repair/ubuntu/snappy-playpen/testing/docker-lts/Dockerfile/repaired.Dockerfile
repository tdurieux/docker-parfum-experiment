FROM ubuntu:xenial

RUN apt update && apt dist-upgrade -y && apt install --no-install-recommends -y snapcraft && apt clean && rm -rf /var/lib/apt/lists/*;

# enable multiverse as snapcraft cleanbuild does.
RUN sed -i 's/ universe/ universe multiverse/' /etc/apt/sources.list
