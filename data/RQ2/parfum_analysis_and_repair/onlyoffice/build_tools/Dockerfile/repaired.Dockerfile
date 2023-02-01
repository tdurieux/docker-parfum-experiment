FROM ubuntu:16.04

ENV TZ=Etc/UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get -y update && \
    apt-get -y --no-install-recommends install python \
                       python3 \
                       sudo && rm -rf /var/lib/apt/lists/*;
RUN rm /usr/bin/python && ln -s /usr/bin/python2 /usr/bin/python
ADD . /build_tools
WORKDIR /build_tools

CMD cd tools/linux && \
    python3 ./automate.py
