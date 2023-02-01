FROM multiarch/debian-debootstrap:arm64-buster

RUN apt-get upgrade -y
RUN apt-get update -qq && apt-get install --no-install-recommends -y make wget ca-certificates && rm -rf /var/lib/apt/lists/*; USER root

RUN wget https://dl.google.com/go/go1.13.linux-arm64.tar.gz
RUN tar -xzf go1.13.linux-arm64.tar.gz && rm go1.13.linux-arm64.tar.gz
RUN mv go /usr/local/
RUN ln -s /usr/local/go/bin/go /usr/bin/
RUN rm -rf /var/lib/apt/lists/* go1.13.linux-arm64.tar.gz
