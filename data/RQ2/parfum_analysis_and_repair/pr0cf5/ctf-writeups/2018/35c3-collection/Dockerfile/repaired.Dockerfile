FROM ubuntu:18.04
RUN apt-get update && apt-get -y --no-install-recommends install python3.6 && rm -rf /var/lib/apt/lists/*;
COPY ./Collection.cpython-36m-x86_64-linux-gnu.so /usr/local/lib/python3.6/dist-packages/Collection.cpython-36m-x86_64-linux-gnu.so
