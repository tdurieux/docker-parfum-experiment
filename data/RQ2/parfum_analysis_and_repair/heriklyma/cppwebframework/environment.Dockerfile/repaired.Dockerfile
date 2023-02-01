FROM ubuntu:16.04

LABEL maintainer="imacellone <italomacellone@gmail.com>"

RUN apt update
RUN apt install --no-install-recommends build-essential -y && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends qt5-default -y && rm -rf /var/lib/apt/lists/*;

COPY ./CPPWebFramework /CPPWebFramework

WORKDIR /CPPWebFramework

RUN qmake CPPWebFramework.pro
RUN make -j8
RUN make install