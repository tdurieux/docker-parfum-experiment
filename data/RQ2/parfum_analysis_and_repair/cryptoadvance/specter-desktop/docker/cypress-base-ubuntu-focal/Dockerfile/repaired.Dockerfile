FROM ubuntu:20.04

RUN apt-get update && \
  apt-get install --no-install-recommends -y apt-transport-https curl && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sL https://deb.nodesource.com/setup_12.x -o nodesource_setup.sh
RUN bash nodesource_setup.sh
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# Install latest NPM and Yarn
RUN npm install -g npm@latest && npm cache clean --force;
RUN npm install -g yarn@latest && npm cache clean --force;

# install additional native dependencies build tools
RUN apt install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;

# install Git client
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
# install unzip utility to speed up Cypress unzips
# https://github.com/cypress-io/cypress/releases/tag/v3.8.0
RUN apt-get install --no-install-recommends -y unzip && rm -rf /var/lib/apt/lists/*;

# avoid any prompts
ENV DEBIAN_FRONTEND noninteractive
#install tzdata package
RUN apt-get install --no-install-recommends -y tzdata && rm -rf /var/lib/apt/lists/*;
# set your timezone
RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime
RUN dpkg-reconfigure --frontend noninteractive tzdata

# install Cypress dependencies (separate commands to avoid time outs)
RUN apt-get install --no-install-recommends -y \
    libgtk2.0-0 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y \
    libnotify-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y \
    libgconf-2-4 \
    libnss3 \
    libxss1 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y \
    libasound2 \
    xvfb && rm -rf /var/lib/apt/lists/*;

# a few environment variables to make NPM installs easier
# good colors for most applications
ENV TERM xterm
# avoid million NPM install messages
ENV npm_config_loglevel warn
# allow installing when the main user is root
ENV npm_config_unsafe_perm true

# versions of local tools
RUN echo  " node version:    $(node -v) \n" \
  "npm version:     $(npm -v) \n" \
  "yarn version:    $(yarn -v) \n" \
  "debian version:  $(cat /etc/debian_version) \n" \
  "user:            $(whoami) \n" \
  "git:             $(git --version) \n"

RUN echo "More version info"
RUN cat /etc/lsb-release
RUN cat /etc/os-release