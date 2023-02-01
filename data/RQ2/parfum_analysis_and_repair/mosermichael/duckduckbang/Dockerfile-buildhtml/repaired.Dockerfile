FROM alpine:3.12
ARG GITHUB_TOKEN=""

RUN apk add --no-cache bash python3 git expect py3-pip g++ libc-dev python3-dev linux-headers
RUN pip3 install --no-cache-dir html5lib
RUN pip3 install --no-cache-dir Brotli
RUN pip3 install --no-cache-dir psutil
RUN pip3 install --no-cache-dir dataclasses-json
RUN pip3 install --no-cache-dir Jinja2

WORKDIR /

COPY *.py /
COPY dcache.py /
ADD  scrapscrap /
COPY scrapscrap /scrapscrap

COPY build/build-html-in-docker.sh /
COPY build/ex /

COPY *.json /
COPY *.template /
COPY flag_list.txt /

CMD GITHUB_TOKEN=${GITHUB_TOKEN} ./build-html-in-docker.sh
