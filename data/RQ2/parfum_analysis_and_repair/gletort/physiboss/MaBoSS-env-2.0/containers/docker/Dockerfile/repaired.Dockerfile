FROM ubuntu:bionic

MAINTAINER Vincent Noel version: 1.0

# Preventing python3-tk from asking timezone
ENV DEBIAN_FRONTEND=noninteractive

# Installing dependencies
RUN apt-get -qq update && apt-get install --no-install-recommends -yq git flex bison gcc g++ python python-pip python3 python3-pip python3-tk && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir matplotlib pandas seaborn xlsxwriter

# Installing MaBoSS
ADD . /opt/MaBoSS-env-2.0
RUN bash -c "cd /opt/MaBoSS-env-2.0; ./check-requirements.sh"
RUN bash -c "cd /opt/MaBoSS-env-2.0/engine/src/; make install"
RUN bash -c "cd /opt/MaBoSS-env-2.0/engine/src/; make MAXNODES=128 install"
RUN bash -c "cd /opt/MaBoSS-env-2.0/engine/src/; make MAXNODES=256 install"

# Exposing port 7777
EXPOSE 7777
EXPOSE 7778
EXPOSE 7779

# Running MaBoSS server
CMD /opt/MaBoSS-env-2.0/engine/pub/MaBoSS-server -q --host 0.0.0.0 --port 7777 \
 & /opt/MaBoSS-env-2.0/engine/pub/MaBoSS_128n-server -q --host 0.0.0.0 --port 7778 \
 & /opt/MaBoSS-env-2.0/engine/pub/MaBoSS_256n-server -q --host 0.0.0.0 --port 7779
