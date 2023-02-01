# Dockerfile for X11-Basic based on the one by Bruno https://github.com/shakenfr/x11basic_docker/
# Start with Ubuntu 20.04
# The docker file generates an installable .deb package of X11-Basic as well as
# the User-Manul as .pdf
# as well as a setup.exe for WINDOWS
#
FROM ubuntu:20.04
VOLUME work
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

#
# Basic Packages
#


RUN apt-get update \
&& apt-get install --no-install-recommends -y apt-utils git tcsh nano vim curl wget make gcc build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y checkinstall imagemagick transfig zip unzip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libsdl-gfx1.2-dev libsdl1.2-dev libsdl-ttf2.0-dev && rm -rf /var/lib/apt/lists/*;

#
# For MQTT Version
#

RUN apt-get install --no-install-recommends -y libssl-dev && rm -rf /var/lib/apt/lists/*;

#
# Crosscompiler for WINDOWS
#
RUN apt-get install --no-install-recommends -y gcc-mingw-w64 wine && rm -rf /var/lib/apt/lists/*;

#
# Prepare for the WINDOWS version
#
RUN dpkg --add-architecture i386
RUN apt-get update
RUN apt-get install --no-install-recommends -y wine32 && rm -rf /var/lib/apt/lists/*;

RUN wget https://files.jrsoftware.org/is/5/isetup-5.5.8.exe 
RUN mkdir -p /root
COPY wineblob.tar.gz /root/
RUN cd /root/; tar xzfv wineblob.tar.gz && rm wineblob.tar.gz
RUN chown -R 0 /root/.wine
#RUN wine isetup-5.5.8.exe

# For some reason this command is needed to initialize wine and its directory
RUN wine cmd /c 'echo %PROGRAMFILES%'


#
# prepare ImageMagic (for Ubuntu)
#
RUN cd /etc/ImageMagick-6/;sed -i 's/"none"/"read | write"/g' policy.xml

#
# get the paho.c library
#

RUN git clone https://github.com/eclipse/paho.mqtt.c.git
RUN cd paho.mqtt.c;git checkout fbf9828200f46e212189d98eaedf8e11281e409a

#
# Special Packages for X11-Basic
#


RUN apt-get install --no-install-recommends -y libreadline-dev xorg-dev libasound2-dev fftw-dev libjpeg-dev \
&& apt-get install --no-install-recommends -y libblas-dev libgmp-dev liblapack-dev libusb-dev libbluetooth-dev libfreetype6-dev && rm -rf /var/lib/apt/lists/*;

#
# Latex Installation for the manual
#
RUN apt-get install --no-install-recommends -y texlive-latex-base texlive-latex-extra texlive-latex-recommended texlive-fonts-extra && rm -rf /var/lib/apt/lists/*;
#
# Some more tex packages
#
RUN apt-get install --no-install-recommends -y texlive-xetex texlive-pstricks texlive-science texlive-formats-extra && rm -rf /var/lib/apt/lists/*;


#
# Crosscompiler for version for ATARI ST TOS
#
RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:vriviere/ppa
RUN apt install --no-install-recommends -y cross-mint-essential && rm -rf /var/lib/apt/lists/*;
#
# Clean up some bit
#
RUN apt-get clean


#
# Get and make X11-Basic
#
RUN echo "Get and make X11-Basic (2)"
RUN git clone https://codeberg.org/kollo/X11Basic.git
RUN mkdir -p X11Basic/src/Debian/Outputs
RUN cd X11Basic/src/; ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr
RUN cd X11Basic/src/;sed -i 's/..\/examples\/compiler\/ybasic/\/X11Basic\/examples\/compiler\/ybasic/g' Makefile
RUN cd X11Basic/src;make;make install
#
# Make the User-Manual
#
RUN mkdir -p X11Basic/doc/manual/Outputs
# corrected upstream
RUN cd X11Basic/doc/manual/tex/;sed -i 's/usepackage{tikz}/usepackage{tikz}\\usepackage{etex}/g' main.tex
RUN cd X11Basic/doc/manual/;make
RUN cp -R X11Basic/doc/manual/Outputs/X11-Basic-manual-*.pdf /
#
# Make the debian package
#
RUN cd X11Basic/src/;sed -i 's/sudo\ checkinstall/checkinstall/g' Makefile; cat Makefile
RUN cd X11Basic/src/;sed -i 's/libreadline7/libreadline8/g' Makefile; cat Makefile
# Now make the debian package
RUN cd X11Basic/src;make static
RUN cd X11Basic/src;make deb
# copy the results in the root of the container
RUN cp -R /X11Basic/src/Debian/Outputs/*.deb /
#
# Prepare stuff for later WINDOWS build
#
RUN cd X11Basic/src;make WINDOWS/lib/SDL.dll WINDOWS/lib/SDL_ttf.dll X11-Basic.iss
RUN cd X11Basic/src;make WINDOWS/lib/libSDL_gfx.a


#
# cleanup
#
RUN cd X11Basic/src;make clean


# for MQTT Version (TODO)
##############################
# get MQTT-hyperdash
RUN git clone https://codeberg.org/kollo/MQTT-Hyperdash.git

RUN cp MQTT-Hyperdash/etc/paho-description-pak paho.mqtt.c/description-pak
RUN cp MQTT-Hyperdash/etc/paho-Makefile paho.mqtt.c/Makefile
RUN cd paho.mqtt.c/;sed -i 's/sudo\ checkinstall/checkinstall/g' Makefile
RUN cd paho.mqtt.c/;sed -i 's/sudo\ chown/chown/g' Makefile
RUN cd paho.mqtt.c;make;make deb




# By default start X11-Basic as a command shell
WORKDIR /work
ENTRYPOINT ["/usr/bin/xbasic"]
