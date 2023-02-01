FROM debian:latest
ENV VERSION=1.5
RUN apt-get --yes update && apt-get --yes dist-upgrade
RUN apt-get --yes --no-install-recommends install coreutils curl xterm && rm -rf /var/lib/apt/lists/*;
RUN curl -f https://packages.mccode.org/debian/mccode.list >/etc/apt/sources.list.d/mccode.list
RUN apt-get --yes update
RUN apt-get --yes --no-install-recommends install mcxtrace-suite-python && rm -rf /var/lib/apt/lists/*;
RUN groupadd docker
RUN useradd -g docker docker
ENV HOME /home/docker
WORKDIR /home/docker
