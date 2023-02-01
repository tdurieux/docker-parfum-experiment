FROM ubuntu:16.04
ENV http_proxy ${http_proxy}
ENV https_proxy ${https_proxy}

RUN apt-get update && apt-get install --no-install-recommends -y \
    openjdk-8-jdk \
    maven \
    python-pip \
    python-dev \
    build-essential \
    libffi-dev \
    libssl-dev \
    subversion \
    git \
    npm && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir fabric

COPY ./ /opt/app/
COPY ./searchcode.sqlite.empty /opt/app/searchcode.sqlite
COPY ./searchcode.properties.example /opt/app/searchcode.properties

RUN rm -rf /opt/app/index
RUN rm -rf /opt/app/repo
RUN rm -rf /opt/app/logs

WORKDIR /opt/app/
