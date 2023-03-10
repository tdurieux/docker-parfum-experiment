FROM artorious/ostis

ENV EXECUTABLE_NAME=wave
ENV TESTS_DIR=graph

RUN cd /ostis && git pull origin master
RUN cd /ostis/sc-machine && git pull origin scp_stable
RUN cd /ostis/sc-web && git pull origin master
RUN cd /ostis/ims.ostis.kb && git pull origin master

RUN mkdir /ostis/code
COPY / /ostis/code