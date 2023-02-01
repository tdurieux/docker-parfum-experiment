FROM ubuntu:latest
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get upgrade -y && apt-get -y --no-install-recommends install \
    tzdata \
    python-pip \
    python-dev \
    nmap \
    curl \
    libffi-dev \
    build-essential \
    libssl-dev && \
    rm -rf /var/lib/apt/lists/*
RUN ln -fs /usr/share/zoneinfo/Etc/UTC /etc/localtime && dpkg-reconfigure --frontend noninteractive tzdata
ADD requirements.txt /
RUN pip install --no-cache-dir --upgrade setuptools pip
RUN pip install --no-cache-dir -r /requirements.txt
RUN pip install --no-cache-dir honcho
ADD . /
RUN find -name "*.sh" -exec chmod 755 {} \;
CMD honcho start
