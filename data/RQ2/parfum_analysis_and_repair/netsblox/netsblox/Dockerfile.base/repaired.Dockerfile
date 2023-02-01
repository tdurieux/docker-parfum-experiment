FROM node:lts
MAINTAINER Brian Broll <brian.broll@vanderbilt.edu>

ENV ENV production
ENV DEBUG netsblox*
ENV NETSBLOX_BLOB_DIR /blob-data

RUN echo installing dependencies..

RUN apt update && apt install --no-install-recommends build-essential libgd-dev libcairo2-dev libcairo2-dev libpango1.0-dev cmake python3-sphinx python3-pip -y && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir sphinx_rtd_theme

RUN echo compiling and installing Gnuplot..
RUN mkdir /tmp/gnuInstall -p
WORKDIR /tmp/gnuInstall
RUN wget https://downloads.sourceforge.net/project/gnuplot/gnuplot/5.2.0/gnuplot-5.2.0.tar.gz
RUN tar -xzvf gnuplot-5.2.0.tar.gz && rm gnuplot-5.2.0.tar.gz
WORKDIR gnuplot-5.2.0
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install
RUN rm -r /tmp/gnuInstall

RUN echo finished installing dependencies

WORKDIR /netsblox
