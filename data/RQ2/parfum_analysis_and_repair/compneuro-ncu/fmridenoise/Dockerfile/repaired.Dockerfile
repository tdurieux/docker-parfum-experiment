# --system configuration--
FROM ubuntu:focal
RUN apt update
RUN apt upgrade
RUN apt install --no-install-recommends -y python3 python3-pip && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y libopenblas-dev liblapack-dev && rm -rf /var/lib/apt/lists/*;
# --fmridenoise installation
ADD . /fmridenoise-src
WORKDIR /fmridenoise-src
RUN python3 setup.py install
# --fmridenoise run
ENTRYPOINT ["fmridenoise"]