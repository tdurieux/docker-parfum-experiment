FROM flask_service:python-3.10-slim-bullseye

RUN mkdir -p /code/data
RUN dd if=/dev/zero of="/code/data/file.txt" bs=1024 count=10240 \
    && dd if=/dev/zero of="/code/data/file.json" bs=1024 count=10240