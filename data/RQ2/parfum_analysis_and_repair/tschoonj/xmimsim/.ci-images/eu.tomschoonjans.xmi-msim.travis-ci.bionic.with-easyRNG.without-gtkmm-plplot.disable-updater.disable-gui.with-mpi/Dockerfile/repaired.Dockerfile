FROM tomschoonjans/xmimsim-travis-ci:bionic.with-easyRNG.without-gtkmm-plplot.disable-updater.disable-gui

RUN apt-get install --no-install-recommends -y libopenmpi-dev openmpi-bin && rm -rf /var/lib/apt/lists/*;
WORKDIR /root

