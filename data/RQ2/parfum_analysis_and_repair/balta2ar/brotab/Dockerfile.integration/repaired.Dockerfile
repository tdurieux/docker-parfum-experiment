FROM ubuntu:21.10

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
  ca-certificates fonts-liberation \
  git fontconfig fontconfig-config fonts-dejavu-core gconf-service gconf2-common \
  libasn1-8-heimdal libasound2 libasound2-data libatk1.0-0 libatk1.0-data libavahi-client3 libavahi-common-data \
  libavahi-common3 libcairo2 libcups2 libdatrie1 libdbus-1-3 libdbus-glib-1-2 libexpat1 libfontconfig1 \
  libfreetype6 libgconf-2-4 libgdk-pixbuf2.0-0 libgdk-pixbuf2.0-common libgmp10 \
  libgnutls30 libgraphite2-3 libgssapi-krb5-2 libgssapi3-heimdal libgtk2.0-0 \
  libgtk2.0-common libharfbuzz0b libhcrypto4-heimdal libheimbase1-heimdal libheimntlm0-heimdal \
  libhx509-5-heimdal libjbig0 libk5crypto3 libkeyutils1 \
  libkrb5-26-heimdal libkrb5-3 libkrb5support0 libnspr4 libnss3 \
  libp11-kit0 libpango-1.0-0 libpangocairo-1.0-0 libpangoft2-1.0-0 libpixman-1-0 libpng16-16 libroken18-heimdal \
  libsasl2-2 libsasl2-modules-db libsqlite3-0 libtasn1-6 libthai-data libthai0 libtiff5 libwind0-heimdal libx11-6 \
  libx11-data libxau6 libxcb-render0 libxcb-shm0 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxdmcp6 \
  libxext6 libxfixes3 libxi6 libxinerama1 libxml2 libxrandr2 libxrender1 libxss1 libxtst6 shared-mime-info ucf \
  x11-common xdg-utils libpulse0 pulseaudio-utils wget libatk-bridge2.0-0 libatspi2.0-0 libgtk-3-0 \
  mesa-va-drivers mesa-vdpau-drivers mesa-utils libosmesa6 libegl1-mesa libwayland-egl1-mesa libgl1-mesa-dri && rm -rf /var/lib/apt/lists/*;

#RUN apt-get update
#RUN apt-get install --yes python-setuptools python-dev curl \
    #    chromium-browser xvfb python3-pip sudo
# RUN apt-get install --yes software-properties-common \
#     python-setuptools python-dev build-essential apt-transport-https curl \
#     chromium-browser firefox curl xvfb python3-pip sudo mc net-tools htop \
#     less lsof
#RUN apt-get update

#RUN easy_install pip
#RUN pip3 install flask httpie
# RUN pip3 install -r /brotab/requirements.txt
#RUN cd /brotab && pip3 install -e .

#ADD xvfb-chromium /usr/bin/xvfb-chromium

ADD deb/google-chrome-stable_current_amd64.deb /tmp/chrome.deb
RUN echo "Installing chrome" && dpkg -i /tmp/chrome.deb

#RUN adduser --disabled-password --gecos '' user
WORKDIR /brotab

# Build:
# docker build -t brotab-integration -f Dockerfile.integration .
# Run:
# xhost +local:docker
#
# docker run --rm --privileged -v "$(pwd):/brotab" -p 10222:9222 -e DISPLAY=unix$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v /dev:/dev -v /run:/run -v /etc/machine-id:/etc/machine-id --ipc=host --device /dev/dri --group-add video brotab-integration
# docker run -it --rm -v "$(pwd):/brotab" -p 10222:9222 -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix brotab

RUN /bin/bash
#RUN /usr/bin/google-chrome --no-sandbox --no-first-run --disable-gpu --remote-debugging-port=10222 --remote-debugging-address=0.0.0.0



# xvfb-run chromium-browser --no-sandbox --no-first-run --disable-gpu --remote-debugging-port=10222 --remote-debugging-address=0.0.0.0 --load-extension=/brotab/brotab/firefox_extension
# curl localhost:9222/json/list
# python3 -m http.server

# cd /brotab && pip3 install -e . && cd /brotab/brotab/firefox_mediator && make install
# chromium-browser --headless --no-sandbox --no-first-run --remote-debugging-port=10222 --remote-debugging-address=0.0.0.0 --load-extension=/brotab/brotab/firefox_extension
# cat ~/.config/chromium/NativeMessagingHosts/brotab_mediator.json
# py.test brotab/tests/test_integration.py -s

# How to run integration tests:
# pip3 install -e .
# bt install --tests
# py.test brotab/tests/test_integration.py -s
# py.test brotab/tests/test_integration.py -k test_active_tabs -s
# pkill python3; pkill xvfb-run; pkill node; pkill Xvfb; pkill firefox

# docker run -it --rm -v "$(pwd):/brotab" -p 127.0.0.1:10222:9222 brotab
# docker run -it --rm -v "$(pwd):/brotab" -p 10222:9222 brotab

# run this on host to be able to view chromimum GUI:
# xhost local:docker
# xhost local:root

# docker run -ti --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix firefox
# docker run -it --rm -v "$(pwd):/brotab" -p 10222:9222 -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix brotab
# xvfb-run chromium-browser --no-sandbox --no-first-run --remote-debugging-port=10222 --remote-debugging-address=0.0.0.0 --load-extension=/brotab/brotab/firefox_extension
# xvfb-run chromium-browser --no-sandbox --no-first-run --disable-gpu --load-extension=/brotab/brotab/extension/chrome

# cd /brotab/brotab/firefox_extension
# web-ext run

# test list tabs:
# curl 'http://localhost:4625/list_tabs'

# EXPOSE 10222:9222
#EXPOSE 10222
# EXPOSE 8000

#RUN /bin/bash












#   FROM ubuntu:16.04
#
#   ENV DEBIAN_FRONTEND noninteractive
#
#   RUN apt-get update
#   RUN apt-get install --yes software-properties-common python-software-properties \
#       python-setuptools python-dev build-essential apt-transport-https curl \
#       chromium-browser firefox curl xvfb python3-pip sudo mc net-tools htop \
#       less lsof
#   #RUN add-apt-repository ppa:chromium-daily/stable
#   RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
#   RUN apt-get update
#   #RUN apt-get install --yes chromium-browser firefox curl xvfb python3-pip sudo mc net-tools htop less
#   # RUN apt-get install --yes xvfb
#   # This will install latest Firefox
#   #RUN apt-get upgrade
#
#   #RUN curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | sudo apt-key add -
#   #RUN echo "deb https://deb.nodesource.com/node_8.x xenial main" | sudo tee /etc/apt/sources.list.d/nodesource.list
#   #RUN echo "deb-src https://deb.nodesource.com/node_8.x xenial main" | sudo tee -a /etc/apt/sources.list.d/nodesource.list
#
#   RUN apt-get install --yes nodejs
#
#   # RUN mkdir /root/.npm-global
#   # ENV PATH=/root/.npm-global/bin:$PATH
#   # ENV NPM_CONFIG_PREFIX=/root/.npm-global
#
#   RUN npm install --global web-ext --unsafe
#
#   RUN easy_install pip
#   RUN pip3 install flask httpie
#   # RUN pip3 install -r /brotab/requirements.txt
#   #RUN cd /brotab && pip3 install -e .
#
#   ADD xvfb-chromium /usr/bin/xvfb-chromium
#   # RUN ln -s /usr/bin/xvfb-chromium /usr/bin/google-chrome
#   # RUN ln -s /usr/bin/xvfb-chromium /usr/bin/chromium-browser
#
#   # RUN useradd --create-home --shell /bin/bash user
#   RUN adduser --disabled-password --gecos '' user
#   # USER user
#   #WORKDIR /home/user
#   WORKDIR /brotab
#
#   # xvfb-run chromium-browser --no-sandbox --no-first-run --disable-gpu --remote-debugging-port=10222 --remote-debugging-address=0.0.0.0 --load-extension=/brotab/brotab/firefox_extension
#   # curl localhost:9222/json/list
#   # python3 -m http.server
#
#   # cd /brotab && pip3 install -e . && cd /brotab/brotab/firefox_mediator && make install
#   # chromium-browser --headless --no-sandbox --no-first-run --remote-debugging-port=10222 --remote-debugging-address=0.0.0.0 --load-extension=/brotab/brotab/firefox_extension
#   # cat ~/.config/chromium/NativeMessagingHosts/brotab_mediator.json
#   # py.test brotab/tests/test_integration.py -s
#
#   # How to run integration tests:
#   # pip3 install -e .
#   # bt install --tests
#   # py.test brotab/tests/test_integration.py -s
#   # py.test brotab/tests/test_integration.py -k test_active_tabs -s
#   # pkill python3; pkill xvfb-run; pkill node; pkill Xvfb; pkill firefox
#
#   # docker run -it --rm -v "$(pwd):/brotab" -p 127.0.0.1:10222:9222 brotab
#   # docker run -it --rm -v "$(pwd):/brotab" -p 10222:9222 brotab
#
#   # run this on host to be able to view chromimum GUI:
#   # xhost local:docker
#   # xhost local:root
#
#   # docker run -ti --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix firefox
#   # docker run -it --rm -v "$(pwd):/brotab" -p 10222:9222 -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix brotab
#   # xvfb-run chromium-browser --no-sandbox --no-first-run --remote-debugging-port=10222 --remote-debugging-address=0.0.0.0 --load-extension=/brotab/brotab/firefox_extension
#   # xvfb-run chromium-browser --no-sandbox --no-first-run --disable-gpu --load-extension=/brotab/brotab/extension/chrome
#
#   # cd /brotab/brotab/firefox_extension
#   # web-ext run
#
#   # test list tabs:
#   # curl 'http://localhost:4625/list_tabs'
#
#   # EXPOSE 10222:9222
#   #EXPOSE 10222
#   # EXPOSE 8000
#
#   RUN /bin/bash
#
