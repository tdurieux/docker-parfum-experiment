FROM i386/ubuntu:18.04

ADD install-shared-deps.sh .
RUN bash ./install-shared-deps.sh

# set paths
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH
ENV LD_LIBRARY_PATH /usr/local/lib:/lib/x86_64-linux-gnu:/usr/lib/x86_64-linux-gnu:/lib32:/usr/lib32