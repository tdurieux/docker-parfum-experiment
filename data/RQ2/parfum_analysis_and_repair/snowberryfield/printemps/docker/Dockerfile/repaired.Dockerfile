FROM ubuntu:18.04
RUN apt-get update && apt-get install --no-install-recommends -y cmake clang g++ git libpthread-stubs0-dev python3 python3-pip wget && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir numpy matplotlib networkx pandas bokeh

CMD ["tail", "-f", "/dev/null"]