FROM ubuntu:trusty

RUN apt-get update
RUN apt-get install --no-install-recommends -y python python-dev python-pip libffi-dev tree && rm -rf /var/lib/apt/lists/*;

# Use the develop branch of tuf for the following fix:
# https://github.com/theupdateframework/tuf/commit/38005fe
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --no-use-wheel git+https://github.com/theupdateframework/tuf.git@develop && pip install --no-cache-dir tuf[tools]

ADD generate.py generate.sh /
CMD /generate.sh
