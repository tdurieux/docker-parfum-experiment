FROM photon:4.0

RUN tdnf install -y shadow >>/dev/null\
    && tdnf clean all \
    && groupadd -r -g 10000 chart \
    && useradd --no-log-init -m -g 10000 -u 10000 chart