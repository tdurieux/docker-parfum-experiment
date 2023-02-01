FROM gcc:latest

RUN apt-get update && apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libfftw3-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libsndfile1-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y automake && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y autoconf && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libtool && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y autoconf-archive && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libgcrypt20-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libzita-resampler-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libmpg123-dev && rm -rf /var/lib/apt/lists/*;

ADD . /audiowmark
WORKDIR /audiowmark

RUN ./autogen.sh
RUN make
RUN make install

VOLUME ["/data"]
WORKDIR /data

ENTRYPOINT ["/usr/local/bin/audiowmark"]
