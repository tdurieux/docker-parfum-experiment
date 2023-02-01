FROM ubuntu:trusty
MAINTAINER Junjue Wang, junjuew@cs.cmu.edu

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install --no-install-recommends -y \
    gcc \
    git \
    python-dev \
    default-jre \
    python-pip \
    pssh \
    python-psutil \
    && apt-get autoremove \
    && apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/cmusatyalab/gabriel.git /gabriel
RUN pip install --no-cache-dir -r /gabriel/server/requirements.txt

WORKDIR /gabriel/server/bin

EXPOSE 9098 9101

# Define default command.
CMD ["bash", "-c", "python gabriel-control & sleep 5;python gabriel-ucomm"]