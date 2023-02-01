FROM ubuntu:bionic
# setup timezone
RUN echo 'Etc/UTC' > /etc/timezone && \
    ln -s /usr/share/zoneinfo/Etc/UTC /etc/localtime

# setup environment
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

RUN apt update && apt install --no-install-recommends -y sudo && apt clean && rm -rf /var/lib/apt/lists/*;

ADD system_install /tmp/system_install
RUN chmod +x /tmp/system_install && /tmp/system_install

