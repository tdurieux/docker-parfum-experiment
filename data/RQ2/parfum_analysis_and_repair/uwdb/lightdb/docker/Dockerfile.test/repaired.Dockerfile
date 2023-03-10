FROM lightdb/core
MAINTAINER Brandon Haynes "bhaynes@cs.washington.edu"

ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility,video

RUN cd build && make lightdb_test
RUN cd build/test && ./lightdb_test