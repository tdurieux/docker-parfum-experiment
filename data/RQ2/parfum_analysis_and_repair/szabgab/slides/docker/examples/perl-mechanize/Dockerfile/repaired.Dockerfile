FROM ubuntu:20.04
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y libtest-www-mechanize-perl && rm -rf /var/lib/apt/lists/*;
