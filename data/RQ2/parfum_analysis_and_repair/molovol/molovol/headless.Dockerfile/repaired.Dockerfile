FROM ubuntu
RUN apt-get update
RUN DEBIAN_FRONTEND="noninteractive" apt-get --no-install-recommends -y install tzdata && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y build-essential manpages-dev libgtk2.0-dev wget && rm -rf /var/lib/apt/lists/*;
RUN wget https://github.com/wxWidgets/wxWidgets/releases/download/v3.1.5/wxWidgets-3.1.5.tar.bz2
RUN tar xvf wxWidgets-3.1.5.tar.bz2 && rm wxWidgets-3.1.5.tar.bz2
WORKDIR  wxWidgets-3.1.5
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --disable-shared --enable-unicode
RUN make install

# hack to create a headless x server, does not work when set in dockerfile?
RUN apt-get install --no-install-recommends xvfb -y && rm -rf /var/lib/apt/lists/*;
ENV DISPLAY=:1.0


#compile molovol
WORKDIR /
COPY Makefile Makefile
COPY src/ src/
COPY include/ include/
RUN make

COPY inputfile/ inputfile/
WORKDIR /src/bin/
COPY launch_headless.sh launch.sh
RUN chmod +x launch.sh
ENTRYPOINT ["/src/bin/launch.sh"]
CMD ["-r", "1.2", "-g", "0.2", "-fs", "/inputfile/isobutane.xyz", "-q", "-o", "time,vol"]