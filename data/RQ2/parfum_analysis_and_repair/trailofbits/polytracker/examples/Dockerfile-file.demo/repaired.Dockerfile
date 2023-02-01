FROM trailofbits/polytracker
MAINTAINER Carson Harmon <carson.harmon@trailofbits.com>
WORKDIR /polytracker/the_klondike

RUN apt update && apt-get install --no-install-recommends automake libtool make python zlib1g-dev git -y && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/file/file.git

RUN echo "temp" > /PLACEHOLDER
ENV POLYPATH=/PLACEHOLDER

#=================================
WORKDIR file
RUN autoreconf -f -i
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/polytracker/the_klondike/bin/ --disable-shared
RUN polytracker build make -j$((`nproc`+1)) install

WORKDIR /polytracker/the_klondike/bin/bin
RUN polytracker instrument-targets file --ignore-lists libz
RUN mv file.instrumented file_track
