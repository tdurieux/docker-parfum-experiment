FROM ubuntu
MAINTAINER Larissa Lages
RUN apt-get update
RUN apt-get install --no-install-recommends -y python3 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-unittest2 && rm -rf /var/lib/apt/lists/*;
COPY ./ ./
CMD python3 -m unittest discover classical_algorithms/python/tests


