FROM ubuntu:18.04
MAINTAINER Florian Schüller <florian.schueller@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
ENV DISPLAY ${DISPLAY:-:1}

ARG TRAVIS=FALSE
ENV TRAVIS=$TRAVIS

ARG TAG=ubuntu_18.04
ENV TAG=$TAG

RUN apt-get update \
 && apt-get -y --no-install-recommends install apt-utils \
 && apt-get -y --no-install-recommends install dirmngr git vim sudo \
 && rm -rf /var/lib/apt/lists/*

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Test specific
# python-wheel is a missing dependency from behave
# psmisc for "killall"
#RUN apt-get update \
# && apt-get -y --no-install-recommends install psmisc ffmpeg x11-utils libxrandr-dev \
# && apt-get -y --no-install-recommends install python-ldtp ldtp python-pip python-wheel python-dogtail python-psutil python-setuptools gdb valgrind tmuxinator tmux \
# && rm -rf /var/lib/apt/lists/*

# Xfce specific build dependencies and default panel plugins
#RUN apt-get update \
# && apt-get -y --no-install-recommends install gnome-themes-standard libglib2.0-bin build-essential libgtk-3-dev gtk-doc-tools libgtk2.0-dev libx11-dev libglib2.0-dev libwnck-3-dev intltool libdbus-glib-1-dev liburi-perl x11-xserver-utils libvte-2.91-dev dbus-x11 strace libgl1-mesa-dev adwaita-icon-theme libwnck-dev adwaita-icon-theme-full cmake libsoup2.4-dev libpcre2-dev exo-utils \
# && apt-get -y --no-install-recommends install xfce4 xfce4-appfinder tumbler xfce4-terminal xfce4-clipman-plugin xfce4-screenshooter xfce4-power-manager xfce4-notifyd \
# && apt-get -y --no-install-recommends build-dep xfce4-panel thunar xfce4-settings xfce4-session xfdesktop4 xfwm4 xfce4-appfinder tumbler xfce4-terminal xfce4-clipman-plugin xfce4-screenshooter \
# && apt-get -y --no-install-recommends libgtksourceview-3.0-dev \
# && apt-get -y --no-install-recommends install xfce4-pulseaudio-plugin xfce4-statusnotifier-plugin \
# && rm -rf /var/lib/apt/lists/*

# Create the directory for version_info.txt
RUN useradd -ms /bin/bash xfce-test_user

RUN adduser xfce-test_user sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN echo "Set disable_coredump false" >> /etc/sudo.conf

COPY --chown=xfce-test_user container_scripts /container_scripts
RUN chmod a+x /container_scripts/*.sh /container_scripts/*.py

# Enable source repositories
RUN sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list

# Xfce specific build dependencies and default panel plugins
RUN /container_scripts/build_time/install_packages-${TAG}.sh

RUN /usr/bin/pip install behave

#needed for LDTP and friends
RUN /usr/bin/dbus-run-session /usr/bin/gsettings set org.gnome.desktop.interface toolkit-accessibility true


# Install _all_ languages for testing
RUN apt-get update \
 && apt-get -y --no-install-recommends install transifex-client xautomation $(apt-cache search language-pack|grep -oP "^language-pack-...?(?= )") \
 && rm -rf /var/lib/apt/lists/*

#RUN pip install opencv-python google-api-python-client oauth2client

# Line used to invalidate all git clones
ARG PARALLEL_BUILDS=0
ENV PARALLEL_BUILDS=$PARALLEL_BUILDS
ARG DOWNLOAD_DATE=give_me_a_date
ENV DOWNLOAD_DATE=$DOWNLOAD_DATE
RUN echo "Newly cloning all repos as date-flag changed to ${DOWNLOAD_DATE}"
ARG AUTOGEN_OPTIONS="--disable-debug --enable-maintainer-mode --host=x86_64-linux-gnu \
                    --build=x86_64-linux-gnu --prefix=/usr --libdir=/usr/lib/x86_64-linux-gnu \
                    --libexecdir=/usr/lib/x86_64-linux-gnu --sysconfdir=/etc --localstatedir=/var --enable-gtk-doc --enable-gtk3 \
                    --enable-vala=yes --enable-introspection=yes --enable-sound-settings"
ENV AUTOGEN_OPTIONS $AUTOGEN_OPTIONS


RUN /container_scripts/build_time/create_automate_langs.sh

RUN dpkg-reconfigure fontconfig

USER xfce-test_user
ENV HOME /home/xfce-test_user

# Group all repos here
RUN sudo mkdir /git && sudo chown xfce-test_user /git

# Rather use my patched version
RUN cd git \
 && git clone -b python3 https://github.com/schuellerf/ldtp2.git \
 && cd ldtp2 \
 && sudo python setup.py install

# fixing to xfce-4.14 mainly for garcon needing newer Automake
# not available in ubuntu 18.04 (by default)
ENV MAIN_BRANCH=xfce-4.14.0

RUN /container_scripts/build_all-${TAG}.sh

COPY --chown=xfce-test_user behave /behave_tests
RUN sudo mkdir /data && sudo chown xfce-test_user /data

COPY --chown=xfce-test_user xfce-test /
RUN chmod a+x /xfce-test
COPY .tmuxinator /home/xfce-test_user/.tmuxinator

RUN mkdir -p ~xfce-test_user/Desktop
RUN ln -s /container_scripts ~xfce-test_user/Desktop/container_scripts
RUN ln -s ~xfce-test_user/version_info.txt ~xfce-test_user/Desktop
RUN mkdir -p ~xfce-test_user/.config
COPY extra_files/mimeapps.list /home/xfce-test_user/.config/

#RUN echo 'if [[ $- =~ "i" ]]; then echo -n "This container includes:\n"; cat ~xfce-test_user/version_info.txt; fi' >> ~xfce-test_user/.bashrc

WORKDIR /data
CMD [ "/container_scripts/entrypoint.sh" ]