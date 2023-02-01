FROM debian:buster-slim

RUN apt-get update

WORKDIR /home/uke/tmp

# Copy build scripts into the container and run them

COPY soil/deps-apt.sh /home/uke/tmp/soil/deps-apt.sh
RUN soil/deps-apt.sh layer-for-soil
RUN soil/deps-apt.sh pea

# deps-tar.sh has a 'wget' step which we're skipping
COPY _cache/Python-3.10.4.tar.xz /home/uke/tmp/_cache/Python-3.10.4.tar.xz

COPY build/common.sh /home/uke/tmp/build/common.sh
COPY soil/deps-tar.sh /home/uke/tmp/soil/deps-tar.sh
RUN soil/deps-tar.sh layer-py3

RUN useradd --create-home uke && chown -R uke /home/uke
USER uke

COPY soil/deps-py.sh /home/uke/tmp/soil/deps-py.sh
RUN soil/deps-py.sh pea

CMD ["sh", "-c", "echo 'hello from oilshell/soil-pea'"]