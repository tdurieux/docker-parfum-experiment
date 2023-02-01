FROM resin/raspberrypi3-debian:latest
# FROM hypriot/rpi-java
#
# WebComponents running on the Raspberry Pi.
# Uses NodeJS
#
LABEL maintainer="Olivier LeDiouris <olivier@lediouris.net>"

# From the host to the image
# COPY bashrc $HOME/.bashrc

RUN echo "alias ll='ls -lisah'" >> $HOME/.bashrc

RUN apt-get update
RUN apt-get install --no-install-recommends -y oracle-java8-jdk && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

RUN echo "git --version" >> $HOME/.bashrc
RUN echo "echo -n 'node:' && node -v" >> $HOME/.bashrc
RUN echo "echo -n 'npm:' && npm -v" >> $HOME/.bashrc
RUN echo "java -version" >> $HOME/.bashrc

RUN mkdir /workdir
WORKDIR /workdir
# TODO Make sure this works...
RUN git clone https://github.com/OlivierLD/raspberry-coffee.git
WORKDIR /workdir/raspberry-coffee/WebComponents

EXPOSE 8080
CMD ["npm", "start"]
