FROM ubuntu

RUN apt-get -y update && apt-get -y --no-install-recommends install curl git upower && rm -rf /var/lib/apt/lists/*;

RUN useradd -ms /bin/bash derf
USER derf
WORKDIR /home/derf
ADD bashrc /home/derf/.bashrc
RUN cat .bashrc | bash
