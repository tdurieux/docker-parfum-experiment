FROM hhvm/hhvm

RUN apt-get update && apt-get install --no-install-recommends -y git curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer