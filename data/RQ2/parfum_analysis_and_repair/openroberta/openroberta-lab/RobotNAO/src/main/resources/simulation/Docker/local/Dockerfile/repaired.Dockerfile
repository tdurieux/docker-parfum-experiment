ARG WEBOTS_VERSION=R2021b-ubuntu20.04

FROM cyberbotics/webots:$WEBOTS_VERSION

RUN apt-get update && apt-get install --no-install-recommends -y firejail python3-pip python-is-python3 firejail python3-pip subversion psmisc && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /home/cyberbotics/simulation && \
    cd /home/cyberbotics/ && svn export https://github.com/cyberbotics/webots/trunk/resources/web/server server && \
    cd /home/cyberbotics/server/ && \
    touch /home/cyberbotics/server/log/output.log

RUN pip3 install --no-cache-dir tornado pynvml psutil requests distro

ENV CONFIG=local

COPY . /home/cyberbotics/simulation
CMD xvfb-run /home/cyberbotics/simulation/Docker/local/start_server.sh
