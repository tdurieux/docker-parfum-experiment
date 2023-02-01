FROM ubuntu
MAINTAINER Tomoki Imai <tomo832@gmail.com>

# Creating the wine user and setting up dedicated non-root environment: replace 1001 by your user id (id -u) for X sharing.
RUN useradd -u 1001 -d /home/wine -m -s /bin/bash wine
ENV HOME /home/wine
WORKDIR /home/wine

# Adding the helper script and an alias to launch the steam to be installed.
COPY finalize_installation.sh /home/wine/.finalize_installation.sh
RUN chown wine:wine /home/wine/.finalize_installation.sh && \
	chmod o+x /home/wine/.finalize_installation.sh && \
	su -p -l wine -c "echo 'alias finalize_installation=\"bash /home/wine/.finalize_installation.sh\"' >> /home/wine/.bashrc" && \
	su -p -l wine -c "echo 'alias steam=\"wine /home/wine/.wine/drive_c/Program\ Files/Steam/Steam.exe\"' >> /home/wine/.bashrc"


# Setting up the wineprefix to force 32 bit architecture.
ENV WINEPREFIX /home/wine/.wine
ENV WINEARCH win32

# Disabling warning messages from wine, comment for debug purpose.
ENV WINEDEBUG -all

# Adding the link to the pulseaudio server for the client to find it.
ENV PULSE_SERVER unix:/run/user/1001/pulse/native

#########################START  INSTALLATIONS##########################

# We don't want any interaction from package installation during the docker image building.
ENV DEBIAN_FRONTEND noninteractive


# Please comment out following line if you are not in Japan
RUN sed -i'~' -E "s@http://(..\.)?(archive|security)\.ubuntu\.com/ubuntu@http://ftp.jaist.ac.jp/pub/Linux/ubuntu@g" /etc/apt/sources.list
# We want the 32 bits version of wine allowing winetricks.
RUN	dpkg --add-architecture i386 && \

# Updating and upgrading a bit.
	apt-get update && \
	apt-get upgrade -y && \

# We need software-properties-common to add ppas.
	apt-get install -y --no-install-recommends software-properties-common && \

# Adding required ppas: graphics drivers and wine.
	add-apt-repository ppa:ubuntu-x-swat/x-updates && \
	add-apt-repository ppa:ubuntu-wine/ppa && \
	apt-get update && \

# Installation of graphics driver.
	apt-get install -y --no-install-recommends nvidia-current && \

# Installation of win, winetricks and temporary xvfb to install winetricks tricks during docker build.
	apt-get install -y --no-install-recommends wine1.7 winetricks xvfb && \
# Installation of winbind to stop ntlm error messages.
	apt-get install -y --no-install-recommends winbind && \
# Installation of pulseaudio support for wine sound.
	apt-get install -y --no-install-recommends pulseaudio:i386 libasound2-plugins:i386 && \
# Will use vlgothic as wine font
	apt-get install -y --no-install-recommends fonts-vlgothic && \
# Installation of winetricks tricks as wine user.
	su -p -l wine -c winecfg && \
	su -p -l wine -c 'xvfb-run -a winetricks -q corefonts' && \
	su -p -l wine -c 'xvfb-run -a winetricks -q dotnet20' && \
	su -p -l wine -c 'xvfb-run -a winetricks -q dotnet40' && \
	su -p -l wine -c 'xvfb-run -a winetricks -q xna40' && \
	su -p -l wine -c 'xvfb-run -a winetricks d3dx9' && \
	su -p -l wine -c 'xvfb-run -a winetricks -q directplay' && \
# Cleaning up.
	apt-get autoremove -y --purge software-properties-common && \
	apt-get autoremove -y --purge xvfb && \
	apt-get autoremove -y --purge && \
	apt-get clean -y && \
	rm -rf /home/wine/.cache && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
#########################END OF INSTALLATIONS##########################

# Install locale
RUN locale-gen ja_JP.UTF-8
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8

RUN cp /usr/share/fonts/truetype/vlgothic/VL-PGothic-Regular.ttf /usr/share/fonts/truetype/vlgothic/VL-Gothic-Regular.ttf /home/wine/.wine/drive_c/windows/Fonts
RUN cat /home/wine/.wine/user.reg
RUN sed -e "s/Ume Gothic/VL Gothic/g" -e "s/Ume P Gothic/VL PGothic/g" -e "s/Ume Mincho/VL Gothic/g" -e "s/Ume P Mincho/VL PGothic/g" -e "s/Ume UI Gothic/VL PGothic/g" -i /home/wine/.wine/user.reg
# Launching the shell by default as wine user.
USER wine
CMD /bin/bash
