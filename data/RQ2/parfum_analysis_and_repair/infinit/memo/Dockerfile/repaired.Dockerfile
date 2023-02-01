FROM debian:jessie

RUN apt-get update

RUN apt-get install --no-install-recommends -y fuse && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y g++ && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libattr1-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y make && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y patch && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y pylint && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-greenlet && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-mako && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y realpath && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir mistune
RUN pip3 install --no-cache-dir orderedset

ADD . /root/fs

WORKDIR /root/fs/_build/linux64
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
RUN python3 ./drake -j $(nproc) //install --prefix=/usr
