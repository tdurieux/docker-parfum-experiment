FROM ubuntu:18.04

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
    git-core \
    ca-certificates && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/qnap-dev/QDK.git
RUN cd /QDK && ./InstallToUbuntu.sh install
COPY build-qpkg.sh /
CMD /build-qpkg.sh
