FROM fedora:latest

RUN yum install -y git protobuf-c protobuf-c-devel make clang-tools-extra clang python3-pip 'dnf-command(builddep)' && \
        dnf builddep -y crun && pip install --no-cache-dir scan-build && rm -rf /var/cache/yum

COPY run-tests.sh /usr/local/bin

ENTRYPOINT /usr/local/bin/run-tests.sh
