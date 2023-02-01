FROM ubuntu:xenial

RUN apt-get update && apt-get install --no-install-recommends -y locales && rm -rf /var/lib/apt/lists/*; # Use UTF-8

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN mkdir /challenge
COPY attachments/qemu-arm /challenge/
COPY attachments/superman /challenge/
RUN set -e -x ;\
    groupadd -g 1337 user ;\
    useradd -g 1337 -u 1337 -m user
RUN set -e -x ;\
    chmod -R 755 /challenge

RUN echo 'CTF{Ill-Take-What-Is-Semi-Hosting-For-400-Alex}' > /flag
