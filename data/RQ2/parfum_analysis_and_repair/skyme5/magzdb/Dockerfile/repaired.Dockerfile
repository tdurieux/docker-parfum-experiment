FROM python:3.10-slim-bullseye

RUN pip install --no-cache-dir -U magzdb

RUN apt update && \
    apt install --no-install-recommends wget --yes && \
    apt-get clean autoclean && \
    apt-get autoremove --yes && rm -rf /var/lib/apt/lists/*;

WORKDIR /tmp

ENTRYPOINT [ "magzdb", "--downloader", "wget" ]