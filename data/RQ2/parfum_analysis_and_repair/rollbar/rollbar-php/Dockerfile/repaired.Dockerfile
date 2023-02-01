FROM shivammathur/node:focal

VOLUME [ "/opt/rollbar/rollbar-php" ]
WORKDIR /opt/rollbar/rollbar-php
ENTRYPOINT [ "/bin/bash" ]

RUN apt-get update \
  && apt-get install --no-install-recommends -y ca-certificates git vim tree && rm -rf /var/lib/apt/lists/*;

RUN spc --php-version "8.0" --extensions "curl" --coverage "xdebug"
