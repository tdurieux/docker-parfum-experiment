FROM ubuntu:16.04

RUN apt-get update && apt-get install --no-install-recommends -y libssl-dev git build-essential wget file software-properties-common libgl1-mesa-dev && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:beineri/opt-qt-5.11.1-xenial && apt-get update && apt-get install --no-install-recommends -y qt511-meta-full && rm -rf /var/lib/apt/lists/*;
RUN echo "/opt/qt511/bin\n/opt/qt511/lib" > /etc/xdg/qtchooser/default.conf
RUN mkdir /work
WORKDIR /work
COPY . /work
RUN mkdir /res
ENV PATH="${PATH}:/opt/qt511/bin"
RUN qmake DESTDIR=/res -o syncmyl2p.mk
RUN make -j4 -f syncmyl2p.mk
RUN bash linux/create_appimage.sh