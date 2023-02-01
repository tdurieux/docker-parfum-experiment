FROM debian
#
# To run on a laptop.
# Demoes the WebComponents.
# With VNC
#
LABEL maintainer="Olivier LeDiouris <olivier@lediouris.net>"

# Following lines may be commented.
#ENV http_proxy http://www-proxy-hqdc.us.oracle.com:80
#ENV https_proxy http://www-proxy-hqdc.us.oracle.com:80
### ENV ftp_proxy $http_proxy
#ENV no_proxy "localhost,127.0.0.1,orahub.oraclecorp.com,artifactory-slc.oraclecorp.com"

# From the host to the image
# COPY bashrc $HOME/.bashrc

RUN echo "alias ll='ls -lisah'" >> $HOME/.bashrc

RUN apt-get update
RUN apt-get install --no-install-recommends -y curl git build-essential default-jdk && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y procps net-tools wget && rm -rf /var/lib/apt/lists/*;

RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install --fix-missing -y mate-desktop-environment-core tightvncserver vim && rm -rf /var/lib/apt/lists/*;
RUN mkdir ~/.vnc
RUN echo "mate" | vncpasswd -f >> ~/.vnc/passwd
RUN chmod 600 ~/.vnc/passwd

RUN apt-get install --no-install-recommends -y chromium && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y inkscape && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y libgtk2.0-dev && rm -rf /var/lib/apt/lists/*;

EXPOSE 5901

RUN useradd -d /home/oliv -ms /bin/bash -g root -G sudo -p oliv oliv

RUN echo "git --version" >> $HOME/.bashrc
RUN echo "echo -n 'node:' && node -v" >> $HOME/.bashrc
RUN echo "echo -n 'npm:' && npm -v" >> $HOME/.bashrc
RUN echo "java -version" >> $HOME/.bashrc
RUN echo "vncserver -version" >> $HOME/.bashrc
RUN echo "alias ll='ls -lisah'" >> $HOME/.bashrc

RUN echo "echo 'To start VNCserver, type: vncserver :1 -geometry 1280x800 -depth 24'" >> $HOME/.bashrc
RUN echo "echo '                       or vncserver :1 -geometry 1440x900 -depth 24'" >> $HOME/.bashrc
RUN echo "echo '                       or vncserver :1 -geometry 1680x1050 -depth 24, etc...'" >> $HOME/.bashrc
RUN echo "echo ' - Note: VNC password is mate'" >> $HOME/.bashrc
RUN echo "echo ' - List TCP ports in use:  netstat -tupln'" >> $HOME/.bashrc

USER root
WORKDIR /home/root
RUN mkdir workdir
WORKDIR workdir

# From local file system to image
COPY ./gtk ./gtk
#    |     |
#    |     In the Docker image
#    On the host (this machine)
#
RUN git clone https://github.com/OlivierLD/raspberry-coffee.git
WORKDIR raspberry-coffee
RUN git clone https://github.com/OlivierLD/AstroComputer.git
WORKDIR ..
RUN git clone https://github.com/OlivierLD/WebComponents.git

#WORKDIR gtk
#RUN gcc `pkg-config --cflags --libs gtk+-2.0` gtktest.c -o gtktest

WORKDIR WebComponents

EXPOSE 8080
# ENTRYPOINT ["npm", "start"]
# CMD ["vncserver", "-fg"]
