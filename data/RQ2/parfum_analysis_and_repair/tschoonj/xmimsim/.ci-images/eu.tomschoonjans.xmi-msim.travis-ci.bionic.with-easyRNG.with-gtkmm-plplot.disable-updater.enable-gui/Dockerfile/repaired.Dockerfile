FROM tomschoonjans/xmimsim-travis-ci:bionic.with-easyRNG.without-gtkmm-plplot.disable-updater.disable-gui

RUN apt-get install --no-install-recommends -y libpeas-dev && rm -rf /var/lib/apt/lists/*;
#RUN apt-get build-dep -y gtkmm-plplot
RUN apt-get install --no-install-recommends -y libgtkmm-plplot2-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR /root

# build gtkmm-plplot from master
#RUN git clone --single-branch --depth=1 https://github.com/tschoonj/gtkmm-plplot.git
#WORKDIR /root/gtkmm-plplot
#RUN autoreconf -i
#RUN ./configure --disable-static
#RUN make -j2
#RUN make install
#RUN make clean
#RUN apt-get remove -y libgtkmm-plplot2
#WORKDIR /root
#ENV PKG_CONFIG_PATH=/usr/local/lib/pkgconfig

