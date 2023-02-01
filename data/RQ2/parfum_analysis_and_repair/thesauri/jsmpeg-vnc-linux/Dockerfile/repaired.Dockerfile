FROM ubuntu:20.04
ENV TZ=Europe/Stockholm
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y cmake && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libx11-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libavutil-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libavcodec-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libswscale-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libxtst-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libssl-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y pkg-config && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y zlib1g-dev && rm -rf /var/lib/apt/lists/*;

RUN git clone --branch v4.1-stable --depth 1 https://github.com/warmcat/libwebsockets.git
RUN mkdir -p jsmpeg-vnc-linux/libwebsockets

WORKDIR jsmpeg-vnc-linux/libwebsockets

RUN cmake /libwebsockets/
RUN make
RUN make install
RUN ls -l bin/

WORKDIR /jsmpeg-vnc-linux/

COPY . ./
RUN cmake .
RUN make

ENV LD_LIBRARY_PATH /usr/local/lib

CMD ["/jsmpeg-vnc-linux/jsmpeg-vnc", "-b", "2000", "-s", "640x480", "-f", "39", "desktop"]

