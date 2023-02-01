FROM ubuntu:trusty

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -q update && apt-get -qy dist-upgrade
RUN apt-get -qy --no-install-recommends install texlive-latex-extra texlive-fonts-recommended texlive-full && rm -rf /var/lib/apt/lists/*;
RUN apt-get -q clean

RUN wget https://tug.org/fonts/getnonfreefonts/install-getnonfreefonts
RUN sudo texlua install-getnonfreefonts
RUN getnonfreefonts -a

WORKDIR /data
VOLUME ["/data"]