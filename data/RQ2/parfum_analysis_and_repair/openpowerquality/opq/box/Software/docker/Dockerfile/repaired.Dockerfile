FROM piersfinlayson/build

RUN sudo apt-get update
RUN sudo apt-get upgrade -y
RUN sudo apt-get install --no-install-recommends -y g++-arm-linux-gnueabihf g++-arm-linux-gnueabi && rm -rf /var/lib/apt/lists/*;


RUN wget https://github.com/zeromq/libzmq/archive/v4.3.1.tar.gz
RUN tar xf v4.3.1.tar.gz && rm v4.3.1.tar.gz
RUN cd libzmq-4.3.1 && ./autogen.sh && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --host=arm-none-linux-gnueabi CC=arm-linux-gnueabi-gcc CXX=arm-linux-gnueabi-g++ && make && sudo make install

