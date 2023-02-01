FROM up9inc/mockintosh:latest

WORKDIR /usr/src/mockintosh

RUN pip3 install --no-cache-dir .[cloud]

WORKDIR /tmp
