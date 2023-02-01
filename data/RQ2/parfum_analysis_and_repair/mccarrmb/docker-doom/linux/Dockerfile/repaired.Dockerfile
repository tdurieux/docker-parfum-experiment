FROM ubuntu:20.04

#Default environment variables
ENV DEBIAN_FRONTEND noninteractive
ENV IWAD /home/zandronum/iwad/doom1.wad
ENV CONFIG /home/zandronum/config/default.cfg
ENV START_MAP E1M1

#Update the OS
RUN apt-get update --yes
RUN apt-get upgrade --yes

#Helper libs for adding PPAs
RUN apt-get install --no-install-recommends --yes dialog apt-utils software-properties-common wget && rm -rf /var/lib/apt/lists/*;

#Specifically add the Zandronum repo and install the application
RUN wget -O - https://debian.drdteam.org/drdteam.gpg | apt-key add -
RUN apt-add-repository 'deb https://debian.drdteam.org stable multiverse'
RUN apt-get update --yes
RUN apt-get upgrade --yes
RUN apt-get install --no-install-recommends --yes --quiet libsdl-image1.2 zandronum && rm -rf /var/lib/apt/lists/*;

#Create a non-privileged user
RUN useradd -ms /bin/bash zandronum
USER zandronum
WORKDIR /home/zandronum

#Build the application directory and add files
RUN mkdir /home/zandronum/config && \
  mkdir /home/zandronum/wad/ && \
  mkdir /home/zandronum/iwad/ && \
  mkdir /home/zandronum/bin/
ADD /config/ /home/zandronum/config/
ADD /bin/ /home/zandronum/bin/
ADD /player/ /home/zandronum/player/
ADD /iwad/ /home/zandronum/iwad/
ADD /wad/ /home/zandronum/wad/

CMD ["/home/zandronum/bin/summon.bash"]
ENTRYPOINT ["/home/zandronum/bin/summon.bash"]
EXPOSE 10666
