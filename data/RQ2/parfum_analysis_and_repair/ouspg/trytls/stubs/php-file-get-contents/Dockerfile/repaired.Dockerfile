FROM  php:latest

RUN apt-get update -y && \
      apt-get install --no-install-recommends git \
      python-pip -y && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/ouspg/trytls.git --depth=1 && \
      cd trytls && \
      pip install --no-cache-dir .

COPY  run.php .
CMD trytls https php run.php
