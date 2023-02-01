FROM balenalib/%%BALENA_MACHINE_NAME%%-node:buster

# Install software packages
RUN install_packages \
  # X Dependencies
    xorg \
    x11vnc \
    xprintidle \
    libgconf2-dev \
  # ElectronJS Dependencies
    clang \
    libnss3-dev \
    libgtk-3-dev \
    libnotify-dev \
    libasound2-dev \
    gnome-keyring

# Echo commands into the X11 conf file to stay awake
RUN echo "#!/bin/bash" > /etc/X11/xinit/xserverrc \
    && echo "" >> /etc/X11/xinit/xserverrc \
    && echo 'exec /usr/bin/X -s 0 -nocursor' >> /etc/X11/xinit/xserverrc

# Move to app dir
WORKDIR /usr/src/app

# Move app to filesystem
COPY ./app ./

# Install npm modules for the application
RUN npm install

# Start app
CMD ["bash", "start.sh"]
