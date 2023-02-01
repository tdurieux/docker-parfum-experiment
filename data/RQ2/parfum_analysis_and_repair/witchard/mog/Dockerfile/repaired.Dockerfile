# Same version of ubuntu as travis
FROM ubuntu:precise

RUN apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -yqq --no-install-recommends \
      python python-pip mediainfo poppler-utils file binutils bsdmainutils vim-common && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir pygments

COPY . /mog

RUN cd /mog && ./test.sh
