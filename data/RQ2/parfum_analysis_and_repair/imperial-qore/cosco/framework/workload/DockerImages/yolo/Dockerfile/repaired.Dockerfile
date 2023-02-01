FROM ubuntu:18.04

WORKDIR /root

RUN \
    apt-get update && apt-get install --no-install-recommends -y \
    autoconf \
    build-essential \
    libtool \
    bc \
    python \
    python-pip \
    automake \
    git && rm -rf /var/lib/apt/lists/*;

RUN \
    apt-get install --no-install-recommends -y \
    wget && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/pjreddie/darknet.git /darknet
WORKDIR /darknet
RUN git checkout f6d861736038da22c9eb0739dca84003c5a5e275
RUN echo '#include <sys/select.h>' > examples/go.c.updated
RUN cat examples/go.c >> examples/go.c.updated
RUN mv examples/go.c.updated examples/go.c
RUN make
RUN wget https://pjreddie.com/media/files/yolov3.weights

RUN mkdir output

COPY execute.sh .
RUN chmod +x execute.sh
COPY assets assets

CMD ["./execute.sh"]

