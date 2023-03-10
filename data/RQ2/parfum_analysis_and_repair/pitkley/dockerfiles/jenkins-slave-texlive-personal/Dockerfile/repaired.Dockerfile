FROM pitkley/jenkins-slave-texlive
MAINTAINER Pit Kleyersburg <pitkley@googlemail.com>

RUN apt-get update && apt-get install -y --no-install-recommends \
        gnuplot \
        make \
        ghostscript \
        python-setuptools \
        && rm -rf /var/lib/apt/lists/*

RUN easy_install pip
RUN pip install --no-cache-dir pygments

RUN sed -i "s/^#\(.*\)StrictHostKeyChecking.*$/\1StrictHostKeyChecking no/g" /etc/ssh/ssh_config

