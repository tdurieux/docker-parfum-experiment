FROM ebbrt/build-environment

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y \
    clang-format-3.8 \
    git \
    iputils-ping \
    netcat \
    python-dev \
    python-pexpect \
    python-pip \
    supervisor \
    texinfo && rm -rf /var/lib/apt/lists/*;
RUN DEBIAN_FRONTEND=noninteractive apt-get upgrade -y











# BuildBot
RUN pip install --no-cache-dir buildbot_slave
RUN groupadd -g 5001 buildbot
RUN useradd -u 5001 -g buildbot buildbot

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
WORKDIR /buildbotslavedata
CMD ["/usr/bin/supervisord"]
