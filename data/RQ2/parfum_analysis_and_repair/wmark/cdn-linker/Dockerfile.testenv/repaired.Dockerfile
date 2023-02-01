FROM mirror.gcr.io/library/php

SHELL ["/bin/bash", "-c"]

RUN if ! command -v unzip &>/dev/null; then \
      apt-get -q update && \
      apt-get -y --no-install-recommends install unzip; \
      find /var -name '*-old' -type f -delete && \
      apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*; \
    fi

RUN if ! command -v composer &>/dev/null; then \
      curl -fsSLR -o /usr/bin/composer https://getcomposer.org/composer-stable.phar; \
      chmod a+x /usr/bin/composer; \
    fi
