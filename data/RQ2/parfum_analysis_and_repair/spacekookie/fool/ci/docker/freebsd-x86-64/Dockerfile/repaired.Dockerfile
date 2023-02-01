FROM japaric/x86_64-unknown-freebsd:latest
MAINTAINER Katharina Fey <kookie@spacekookie.de>

RUN apt-get update && apt-get install --no-install-recommends -y libncurses5 \
                        libncursesw5 \
                        libncurses5-dev \
                        libncursesw5-dev && rm -rf /var/lib/apt/lists/*;

