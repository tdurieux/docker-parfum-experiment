FROM circleci/node:latest

RUN sudo rm -rf /var/lib/apt/lists/* /var/cache/apt/*

RUN sudo rm -rf /var/cache/apt/archives && sudo ln -s ~/.apt-cache /var/cache/apt/archives && mkdir -p ~/.apt-cache/partial

RUN sudo dpkg --add-architecture i386

RUN sudo apt-get update -y && sudo apt-get install -y --no-install-recommends g++-multilib lib32z1 lib32ncurses5 libbz2-1.0:i386 && rm -rf /var/lib/apt/lists/*;

RUN sudo apt-get update -y && sudo apt-get install -y --no-install-recommends g++-multilib lib32z1 lib32ncurses5 \
  rpm fakeroot dpkg libdbus-1-dev libx11-dev \
  libdbus-1-dev:i386 libexpat1-dev:i386 libx11-dev:i386 libc6-dev-i386 \
  g++ libavahi-compat-libdnssd-dev libgtk2.0-0 \
  gcc-4.8-multilib g++-4.8-multilib libnotify4 xvfb && rm -rf /var/lib/apt/lists/*;

RUN sudo apt-get update -y && sudo apt-get install --no-install-recommends -y \
    build-essential ca-certificates curl clang \
    libgnome-keyring-dev libnss3 libgtk2.0-dev \
    libnotify-dev libdbus-1-dev libxrandr-dev \
    libxext-dev libxss-dev libgconf2-dev libasound2-dev \
    libcap-dev libcups2-dev libXtst-dev wget && rm -rf /var/lib/apt/lists/*;

RUN sudo apt-get update -y && sudo apt-get install -y --no-install-recommends libgconf-2-4 && rm -rf /var/lib/apt/lists/*;

RUN sudo apt-get install -y --no-install-recommends libxss1 && rm -rf /var/lib/apt/lists/*;

RUN sudo npm i -g npm@3 && npm cache clean --force;

CMD [ "node" ]