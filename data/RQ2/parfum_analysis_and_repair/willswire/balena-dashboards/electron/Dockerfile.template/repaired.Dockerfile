FROM balenalib/%%BALENA_MACHINE_NAME%%-node

# Install software packages
RUN install_packages \
  # X Dependencies
  xorg \
  x11vnc \
  cups-client \
  xserver-xorg-video-all \
  # ElectronJS Dependencies
  clang \
  libnss3-dev \
  libgtk-3-dev \
  libnotify-dev \
  libasound2-dev \
  gnome-keyring

# Move to app dir
WORKDIR /usr/src/app

# Copy files to filesystem
COPY ./main.js ./
COPY ./start.sh ./
COPY ./package.json ./

# Install npm modules for the application
RUN npm install && npm cache clean --force;

# Start app
CMD bash start.sh
