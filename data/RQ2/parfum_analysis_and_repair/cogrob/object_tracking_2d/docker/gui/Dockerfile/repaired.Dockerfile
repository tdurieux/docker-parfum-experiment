#From inside this folder
# docker build -t cogrob/ebt-gui .

############################################################
# Dockerfile to build EBT images
# Based on Ubuntu
############################################################

FROM cogrob/ebt-dev
MAINTAINER Cognitive Robotics "http://cogrob.org/"

# Intall some basic GUI and sound libs
RUN apt-get install --no-install-recommends -y \
		xz-utils file locales dbus-x11 pulseaudio dmz-cursor-theme \
		fonts-dejavu fonts-liberation hicolor-icon-theme \
		libcanberra-gtk3-0 libcanberra-gtk-module libcanberra-gtk3-module \
		libasound2 libgtk2.0-0 libdbus-glib-1-2 libxt6 libexif12 \
		libgl1-mesa-glx libgl1-mesa-dri \
  && update-locale LANG=C.UTF-8 LC_MESSAGES=POSIX && rm -rf /var/lib/apt/lists/*;

# Intall some basic GUI tools
RUN apt-get install --no-install-recommends -y \
	terminator \
	cmake-qt-gui \
	gedit && rm -rf /var/lib/apt/lists/*;