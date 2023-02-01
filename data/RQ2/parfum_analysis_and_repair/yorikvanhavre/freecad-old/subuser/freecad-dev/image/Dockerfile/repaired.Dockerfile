FROM ubuntu:14.04
RUN apt-get update
RUN apt-get install --no-install-recommends -yqq software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:freecad-maintainers/freecad-daily
RUN apt-get update
RUN apt-get install --no-install-recommends -yqq build-essential python python2.7-dev subversion cmake libtool autotools-dev automake bison flex gfortran git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -yqq libCoin80-dev libCoin80-doc libsoqt4-dev libqt4-dev qt4-dev-tools libsoqt4-dev python-qt4 libqtwebkit-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -yqq liboce-foundation-dev liboce-modeling-dev liboce-ocaf-dev liboce-visualization-dev oce-draw && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -yqq libode-dev libeigen2-dev libeigen3-dev libsimage-dev libxerces-c2-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -yqq libpyside-dev pyside-tools libshiboken-dev doxygen python-pivy && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -yqq libboost1.55-all-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -yqq libmedc-dev libvtk6-dev libproj-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -yqq libxerces-c-dev && rm -rf /var/lib/apt/lists/*;
RUN ln -s /usr/lib/x86_64-linux-gnu/libxerces-c.so /usr/lib/libxerces-c.so
