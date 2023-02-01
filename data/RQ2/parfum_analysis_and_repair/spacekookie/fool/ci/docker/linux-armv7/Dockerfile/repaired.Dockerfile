FROM japaric/armv7-unknown-linux-gnueabihf:latest
MAINTAINER Katharina Fey <kookie@spacekookie.de>

RUN apt-get update && apt-get install --no-install-recommends -y lib32ncurses5 \
                        lib32ncursesw5 \
                        lib32ncurses5-dev \
                        lib32ncursesw5-dev && rm -rf /var/lib/apt/lists/*;
