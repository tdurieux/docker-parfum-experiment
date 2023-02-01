FROM ubuntu:20.04
COPY . /usr/src/
WORKDIR /usr/src/experiments/growing
RUN apt-get update -y && apt-get install --no-install-recommends -y make gcc g++ python2 python-is-python2 && rm -rf /var/lib/apt/lists/*;
RUN /usr/src/experiments/growing/build.sh
CMD ["bash", "run.sh"]
