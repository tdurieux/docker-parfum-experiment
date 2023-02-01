FROM keyiz/kratos

LABEL description="Latest Kratos build with all the toolchains"
LABEL maintainer="keyi@cs.stanford.edu"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
        apt-get install -y --no-install-recommends tcl clang build-essential git verilator csh && \
        ln -fs /usr/share/zoneinfo/America/Los_Angeles /etc/localtime && \
        dpkg-reconfigure --frontend noninteractive tzdata && \
        apt-get clean && rm -rf /var/lib/apt/lists/*

RUN rm /bin/sh && ln -s /bin/bash /bin/sh