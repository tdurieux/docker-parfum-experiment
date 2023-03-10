FROM dorowu/ubuntu-desktop-lxde-vnc:bionic

RUN sed -i 's#mirror://mirrors.ubuntu.com/mirrors.txt#http://archive.ubuntu.com/ubuntu/#g' /etc/apt/sources.list

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        libjpeg-dev zlib1g-dev xfonts-intl-chinese xfonts-wqy locales && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        python3-pip python3-dev python3-tk build-essential && rm -rf /var/lib/apt/lists/*;

COPY ./requirements.txt /tmp/requirements.txt

RUN python3 -m pip install setuptools wheel && python3 -m pip install -r /tmp/requirements.txt
