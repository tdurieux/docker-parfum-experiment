FROM tomschoonjans/xmimsim-travis-ci:bionic.with-fgsl.with-gtkmm-plplot.disable-updater.enable-gui

RUN apt-get install --no-install-recommends -y libjson-glib-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR /root
