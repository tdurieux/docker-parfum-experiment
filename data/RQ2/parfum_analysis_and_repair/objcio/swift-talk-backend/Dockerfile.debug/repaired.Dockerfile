FROM swift:5.0.1

# workaround to make this work with the swift 5 image:
# https://forums.swift.org/t/lldb-install-precludes-installing-python-in-image/24040
RUN  mv /usr/lib/python2.7/site-packages /usr/lib/python2.7/dist-packages; ln -s dist-packages /usr/lib/python2.7/site-packages

RUN apt-get update
RUN apt-get install --no-install-recommends -y postgresql libpq-dev cmake && rm -rf /var/lib/apt/lists/*;

WORKDIR /app

# cmark
RUN git clone -b '0.29.0' https://github.com/commonmark/cmark
RUN make -C cmark INSTALL_PREFIX=/usr/local
RUN make -C cmark install

# javascript deps

RUN apt-get install --no-install-recommends --yes curl nodejs npm && rm -rf /var/lib/apt/lists/*;

RUN update-alternatives --install /usr/bin/node node /usr/bin/nodejs 10

COPY package.json package-lock.json ./
RUN npm install && npm cache clean --force;

COPY assets ./assets
COPY Package.swift LinuxMain.swift ./
RUN swift package update

COPY Sources ./Sources
COPY Tests ./Tests

# workaround for -libcmark linker flag instead of -lcmark
RUN ln -s /usr/local/lib/libcmark.so /usr/local/lib/liblibcmark.so
RUN swift build --configuration debug -Xswiftc -g

RUN apt-get install --no-install-recommends --yes screen lldb && rm -rf /var/lib/apt/lists/*;

EXPOSE 8765
CMD ["lldb .build/release/swifttalk-server"]
