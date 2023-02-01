FROM ubuntu:vivid
MAINTAINER Sébastien Rannou <mxs@sbrk.org> (@aimxhaisse)

RUN apt-get update -q -y \
    && apt-get install --no-install-recommends -q -y \
       python3 \
       opensmtpd \
       openssl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*;

ADD sync.py /sync.py

ENTRYPOINT /sync.py
