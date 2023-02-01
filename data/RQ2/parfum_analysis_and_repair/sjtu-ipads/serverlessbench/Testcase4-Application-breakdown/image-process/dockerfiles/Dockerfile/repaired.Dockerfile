from openwhisk/java8action

RUN apt-get update \
        && apt-get install --no-install-recommends -y imagemagick-6.q16 && rm -rf /var/lib/apt/lists/*;
