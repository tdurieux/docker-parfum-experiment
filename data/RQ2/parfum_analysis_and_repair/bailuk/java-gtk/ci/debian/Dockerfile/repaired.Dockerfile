# Creates an image containing everything to build this project
# Based on https://hub.docker.com/_/debian/

# podman build -t build-on-debian .
# podman run -it --name build-on-debian build-on-debian
# -> ./clone-and-build.sh


FROM docker.io/debian:bookworm
LABEL version="0.5"

ENV JAVA_TOOL_OPTIONS "-Dfile.encoding=UTF8"

COPY clone-and-build.sh clone-and-build.sh
RUN chmod +x clone-and-build.sh

RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y --no-install-recommends install libgtk-4-1 && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install openjdk-11-jdk && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libgirepository1.0-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install fakeroot && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install devscripts && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y clean

