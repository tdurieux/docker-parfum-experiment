FROM ubuntu:16.04

RUN apt-get update \
    && apt-get install --no-install-recommends -y fio gnuplot \
    && apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN bash -c 'mkdir -p /{templates,datadir,logdir}'

COPY fio-runner.sh /

