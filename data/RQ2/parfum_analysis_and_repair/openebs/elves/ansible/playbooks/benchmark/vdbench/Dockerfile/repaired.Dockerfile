FROM ubuntu:16.04

RUN apt-get update \
    && apt-get install --no-install-recommends -y csh default-jre gnuplot \
    && apt-get clean && rm -rf /var/lib/apt/lists/*;

COPY vdb /vdb/
COPY vdbench-runner.sh vdb2gnuplot.sh /

RUN bash -c 'mkdir -p /{templates,datadir,logdir}'

